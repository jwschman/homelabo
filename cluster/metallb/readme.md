# metallb

## Notes

### Installation

Installed following the [Installation with Helm](https://metallb.io/installation/#installation-with-helm) page configured with the [Layer 2 configuration](https://metallb.io/configuration/#layer-2-configuration) section.

### bgppeers crd out of sync in ArgoCD

The bgppeers.metallb.io CRD's caBundle gets mutated by Kubernetes and would always show as out of sync in ArgoCD as a result.  In `/cluster-app-of-apps/metallb.yaml` I added a ignoreDifferences to the spec so that it would no longer show as out of sync.
