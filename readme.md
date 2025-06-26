# ホームラボ (HomeLabo)

[![Kubernetes](https://img.shields.io/badge/Powered%20by-Kubernetes-blue?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-blue?logo=argo)](https://argo-cd.readthedocs.io/)
[![CC0](https://img.shields.io/badge/license-CC0%201.0-lightgrey)](https://creativecommons.org/publicdomain/zero/1.0/)
[![Last Commit](https://img.shields.io/github/last-commit/jwschman/homelabo)](https://github.com/jwschman/homelabo/commits)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://github.com/renovatebot/renovate)
[![TruffleHog Scanned](https://img.shields.io/badge/secret%20scan-TruffleHog-success?logo=trufflehog&logoColor=white)](https://github.com/trufflesecurity/trufflehog)

My personal kubernetes based homelab, nicknamed HomeLabo, built for learning, experimentation, and daily use.  [Why labo and not lab?](https://legendsoflocalization.com/articles/japan-labo-love/)

>This documentation is an ongoing project and may be incomplete in some areas.

## Introduction

This repository is ***the*** source of truth for HomeLabo.  It's designed to be declarative, reproducible, and easy to understand.

---

## Core Values

These are the principles that guide how I build and manage HomeLabo.

### Automation and Repeatability

Automation and repeatability are my most important values for this project.  If things fail in wild and spectacular ways I want to be able to quickly get them back into a working state as quickly and easily as possible.  GitOps, declarative configurations, and easy to follow guides and notes allow me to quickly and easily deploy new services and configurations, rollback as needed, or completely rebuild from scratch when necessary.

>Check [docs/setup](docs/setup/) for information on how the cluster is built.

### Doing Things Right

From the start I wanted to build things the *right* way, even if it takes more time.  I quickly learned that in the bare-metal Kubernetes world there isn't exactly a single right way to do things, but I did try to follow as many best practices as possible.  This approach makes things more clear and allows for easier troubleshooting.

### Maintainability

Everything in HomeLabo should be easy to update, upgrade, build, and tear down.

### Security

Security should obviously be a core value of any homelab project.  While the configuration for HomeLabo is public, the actual services are not and I want things to stay that way.  This means keeping things as secure as possible and following security best practices wherever feasible.  Since the cluster itself is not publically accessible, some of measures may be overkill for a private setup, but they're great for learning and gaining practical experience.  

> More information about some of my security practices can be found in the [external-secrets `readme.md`](cluster/external-secrets/readme.md) and in the [Secrets Scanning with TruffleHog](#secrets-scanning-with-trufflehog) section.

### GitOps

The previous three values all lead to GitOps.  Aside from a few very specific instances, everything in this cluster is managed through GitOps.  If it’s not in this repo, it’s not in the cluster.  This ensures full visibility into what’s running, enables reliable deployments, and makes rollbacks simple.

### Documentation

Good documentation of everything in this environment is another primary goal.  From the start I wanted clear, step-by-step guides for setup as well as explanations for choices I've made so myself and others can follow along easily.  This is handled both through the `readme.md`s and `notes.md`s inside specific directories as well as posts on my [github.io page](https://jwschman.github.io).

### Learning

This homelab was originally built as, and continues to be, a platform for me to learn Kubernetes.  I use it to explore Kubernetes and related technologies while also running services used by me and my family every day.

---

## Cluster Architecture

All nodes are running **Ubuntu 24.04.1 LTS**.  Hosts are provisioned using cloud-init scripts I wrote following this wonderful guide:

[https://www.jimangel.io/posts/automate-ubuntu-22-04-lts-bare-metal/](https://www.jimangel.io/posts/automate-ubuntu-22-04-lts-bare-metal/)

>**Note:** I'm thinking about making a to switch to **[Talos Linux](https://www.talos.dev)** in the future.

### Hardware

The cluster is built with a physical stack of Lenovo ThinkCenters that I bought used from Yahoo Auctions Japan.  It's is inexpensive, compact, and power-efficient while being more than powerful enough for my needs.  

- **control-plane**: Lenovo ThinkCentre M710q
- **worker-01**: Lenovo ThinkCentre M910q
- **worker-02**: Lenovo ThinkCentre M920q

### Network

I chose [Calico](https://github.com/projectcalico/calico) as my CNI for its simplicity.  It is installed during [kubernetes-install-guide](docs/setup/kubernetes-install-guide.md) through helm using a custom `values.yaml`.

[MetalLB](https://github.com/metallb/metallb) provides IP addresses for LoadBalancer type services.

I run [two separate instances of ingress-nginx](https://github.com/kubernetes/ingress-nginx) for [internal](cluster/ingress-nginx/internal/) and [external](cluster/ingress-nginx/external/) traffic.  Doing things this way helps me be absolutely sure that I won't accidentally expose something to the internet.  

>**Note:** I'm exploring other ways to handle both Ingress and externally exposed services.

### External Hardware and Services

There are a few pieces of hardware and services that are used by the cluster but not directly a part of it.

- **TrueNAS**: A custom built Ryzen based machine running [**TrueNAS Core**](https://www.truenas.com/truenas-core/).  Provides NFS shared storage for persistent volumes and backups.
- [**Dousojin**](https://en.wikipedia.org/wiki/D%C5%8Dsojin): A Raspberry Pi 3B+ running Docker.  It hosts [**Hashicorp Vault**](https://github.com/hashicorp/vault) which HomeLabo relies on for external secrets.
- **Central Bureaucracy**: An Ubuntu VM hosted on **TrueNAS** used for central management of everything.  Kubectl, Helm, Vault CLI, Argo CLI and others can all be run from here.

### Storage and Secret Flow

![Storage and Secret Flow](images/homelabo-storage-and-secret%20flow.png)

## Installed Apps

Everything is installed and managed with ArgoCD through Applications in the [applicationsets](/applicationsets) directory.

### bootstrap-apps

This is an ArgoCD "[app-of-apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/)" containing all of the infrastructure components used by the cluster.

<table>
    <tr>
        <td><a href="https://github.com/cert-manager/cert-manager">authentik</a></td>
        <td>Open-source Identity Provider</td>
    </tr>
    <tr>
        <td><a href="https://github.com/cert-manager/cert-manager">cert-manager</a></td>
        <td>Automatic generation and renewal of TLS certificates</td>
    </tr>
    <tr>
        <td><a href="https://github.com/kubernetes-csi/csi-driver-nfs">NFS CSI driver for Kubernetes</a></td>
        <td>Dynamic provisioning of PVs via NFS</td>
    </tr>
    <tr>
        <td><a href="https://github.com/kubernetes-sigs/external-dns">ExternalDNS</a></td>
        <td>Automatic DNS record creation</td>
    </tr>
    <tr>
        <td><a href="https://github.com/external-secrets/external-secrets">External Secrets</a></td>
        <td>Pull Kubernetes secrets from external providers</td>
    <tr>
        <td><a href="https://github.com/kubernetes/ingress-nginx">Ingress NGINX Controller</a></td>
        <td>Ingress controller.  I run dual instances for internal and external access</td>
    </tr>
    <tr>
        <td><a href="https://github.com/longhorn/longhorn">Longhorn</a></td>
        <td>Distributed block storage system</td>
    </tr>
    <tr>
        <td><a href="https://github.com/metallb/metallb">MetalLB</a></td>
        <td>Bare-metal load balancer for Kubernetes</td>
    </tr>
</table>

### home-server

This is the ArgoCD ApplicationSet used to deploy everything in the apps directory of this repo.  Each subdirectory of apps gets its own namespace.

> I should really change the name of this to HomeLabo to match the theme of the cluster, rather than the home-server name that I got from a guide I followed.

<table>
    <tr>
        <td>argocd</td>
        <td>Helm chart for ArgoCD to manage itself</td>
    </tr>
    <tr>
        <td>gotify</td>
        <td>Gotify centralized notifications</td>
    </tr>
    <tr>
        <td>linkwarden</td>
        <td>Webpage saving</td>
    </tr>
    <tr>
        <td>monitoring</td>
        <td>Contains charts for grafana, node-exporter, prometheus, smartctl-exporter, truenas-graphite-exporter and uptime-kuma</td>
    </tr>
    <tr>
        <td>nextcloud</td>
        <td>Cloud file storage</td>
    </tr>
    <tr>
        <td>paperless</td>
        <td>Document storage</td>
    </tr>
    <tr>
        <td>redis</td>
        <td>Centralized redis server</td>
    </tr>
    <tr>
        <td>redmine</td>
        <td>Issue tracking</td>
    </tr>
    <tr>
        <td>truenas-gotify-adapter</td>
        <td>TrueNAS notifications in Gotify</td>
    </tr>
    <tr>
        <td>wordpress</td>
        <td>Personal writing</td>
    </tr>
</table>

---

## Setup & Runbooks
- [Provisioning Hosts](docs/setup/kubernetes-install-guide.md)
- [Installing ArgoCD and all apps](docs/setup/argocd-install-guide.md)

---

## Secrets Scanning with TruffleHog

Because this is a public repo for services I actually use in my homelab environment, making sure I don't expose any secrets is critical.  I use external secrets wherever possible but there's always the chance I make a mistake somewhere.  That's where [TruffleHog🐽](https://github.com/trufflesecurity/trufflehog) helps.  

TruffleHog scans this repository for exposed included secrets and reports them back to me.  This is achieved via a pre-commit hook configured using [this handy guide](https://github.com/trufflesecurity/trufflehog/blob/main/PreCommit.md).  Using a pre-commit hook means I catch potential issues **before** anything is put into a commit and leaves my local machine.  This avoids the risk of ever pushing secrets upstream in the first place.  It can also be run on its own or as a GitHub action, but in my case I want to make sure that all my commits are safe to avoid any cleanup later.

---

## Boilerplates

This repo also contains [reusable boilerplate manifests](/boilerplates/) that I reference frequently.

---

## License

All configuration files and documentation in this repository are released into the public domain under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## Attribution

Some configurations used in this repository are inspired by or derived from publicly available open-source projects or guides.  Attributions and links to original sources are provided in their respective directories where applicable.
