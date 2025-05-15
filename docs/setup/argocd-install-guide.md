# ArgoCD Setup Guide

> Note: This guide is part of my personal homelab repository, and includes specifics for my environment (e.g. IP addresses, DNS entries, hostnames).

This guide describes how to install and bootstrap ArgoCD on a Kubernetes cluster using Helm and ApplicationSets. It assumes the cluster is already initialized with `kubeadm`, and `kubectl` is configured and functional. This setup is used to manage the deployment of all apps via GitOps grom this Github repo.

> Note: central-bureaucracy is a VM I use for remotely managing all my homelab related services.  It has kubectl, helm, argocd, vault and others already configured.

## Step 1: Install and prepare ArgoCD through helm on central-bureaucracy

> **I had to remove the project: default from the credentials for it to work with ApplicationSet**

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd --create-namespace -f argocd-init/values.yaml
```

*OPTIONAL:  This initial setup of ArgoCD uses a NodePort so I can access the WebUI at `http://<node-ip>:30080` to see if it is running correctly.*

> In my setup, the IP is `192.168.1.251`. You can check with:
>
> ```bash
> kubectl get svc -n argocd
> ```

## Step 2: Apply the ArgoCD app-of-apps bootstrap manifest

This manifest defines a single ArgoCD application using the app of apps pattern to manage the infrastructure of the cluster.  It points to the individual ArgoCD applications inside the `cluster-app-of-apps` directory to be deployed by Argo.

```bash
kubectl apply -n argocd -f applicationsets/bootstrap.yaml
```

Things should be good to go within a few moments.  The cert may take up to 30 minutes to get, but it's unnecessary for everything else.

## Step 3: Apply the main applicationset manifest

This will deploy all the apps included inside the apps folder.

```bash
kubectl apply -n argocd -f applicationsets/applicationset.yaml
```

## TODO

I'm still working on automating the full Longhorn restore process from backups. Once complete, that step will go **after step 2**, so the volumes are ready before deploying apps.
