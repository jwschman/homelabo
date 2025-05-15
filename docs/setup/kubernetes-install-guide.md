# Preparing Kubernetes Hosts for ArgoCD Deployment

This is my personal guide for provisioning and configuring Ubuntu-based physical machines into a working Kubernetes cluster to be managed via ArgoCD.

It includes:

- Installing Ubuntu using automated cloud-init.
- Running Ansible playbooks on each host to prepare them to run as a Kubernetes cluster.
- Initializing Kubernetes using `kubeadm`.
- Installing Calico CNI.
- Joining worker nodes.
  
> This guide is primarily for my own use but is shared publicly in case others may find it useful.

**cluster layout:**

- `control-plane` – Kubernetes control plane node
- `worker-01` / `worker-02` – Worker nodes
- `central-bureaucracy` – External management VM with `kubectl`, `helm`, `ansible`, etc.

## Step -1: Provision the hosts

> I'll cover preparing the USBs for cloud-init here in a post on my [github.io page](jwschman.github.io).

For each host:

1. Plug in both the USBs (cloud-init and ventoy) to the computer being prepared
1. Power on the machine and select the correct ISO - boot in normal mode
1. At grub menu, highlight **Try or Install Ubuntu** and press `e` to edit...
1. Append `autoinstall quiet` to the line with `linux   /casper/vmlinuz`
1. Press `F10`, and then let it go...
1. After the computer shuts down remove both USBs and turn it on one more time
1. When the computer shuts down again, it's ready to go

Repeat for each host (3 times total in my case).

## Step 0: Prepare the fresh hosts with Ansible Playbooks

**Run these from central-bureaucracy inside the `~/ansible-playbooks` directory**

```bash
ansible-playbook -i inventory.ini 1-init.yml
ansible-playbook -i inventory.ini 2-install-containerd.yml
ansible-playbook -i inventory.ini 3-configure-containerd-and-install-kubernetes.yml
```

I'll also cover these ansible playbooks in a post on my [github.io page](jwschman.github.io) in the future, but here is a quick summary of what they do:

### `1-init.yml`

- set hostnames and update `/etc/hosts`
- disable swap and UFW
- set required kernel modules and sysctl parameters
- install common packages

### `2-install-containerd.yml`

- download and install containerd services
- install runc and CNI plugins

### `3-configure-containerd-and-install-kubernetes.yml`

> I should really move the steps that configure containerd into Step 2.  This is the remnants from a previous script

- generate and modify default containerd configuration (set `SystemCgroup`)
- set pause image
- enable and start containerd service
- add Kubernetes package repository
- install `kubelet`, `kubeadm` and `kubectl`
- mark Kubernetes packages as held

---

## Step 1: Initialize the cluster

> **from control-plane**

```bash
# Initialize cluster
sudo kubeadm init --apiserver-advertise-address=192.168.1.250 --pod-network-cidr=10.100.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

**switch to **central_bureaucracy** and get kubernetes config**

```bash
# Copy config to central_bureaucracy
scp -i .ssh/john2025 -r john@control-plane:/home/john/.kube .
```

> **Note:** This command uses my personal SSH key and username.  Update as needed.

## Step 2: Set up Calico

> **still from central_bureaucracy**

```bash
helm repo add projectcalico https://docs.tigera.io/calico/charts
kubectl create namespace tigera-operator
helm install calico projectcalico/tigera-operator \
  --version v3.29.2 \
  -f setup/calico/values.yaml \
  --namespace tigera-operator
```

> **Note:** Ensure the `--pod-network-cidr` used in `kubeadm init` matches the one defined in your Calico Helm values (`10.100.0.0/16` in this case).

## Step 3: Join the worker nodes

> **switch to control-plane**

Get the join command to be used on the worker nodes

```bash
kubeadm token create --print-join-command
```

Run the join command with `sudo` on all worker nodes (`worker-01` and `worker-02` in my case)."

> **switch back to central-bureaucracy**

Finally, set the worker node roles

```bash
kubectl label node worker-01 node-role.kubernetes.io/worker=true
kubectl label node worker-02 node-role.kubernetes.io/worker=true
```

---

After all steps are completed successfully you can continue to the `argocd-install-guide.md` guide.

---

## References

- Calico Setup Docs: <https://kifarunix.com/install-and-setup-kubernetes-cluster-on-ubuntu-24-04/>
