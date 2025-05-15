# argocd-init

Contains the `values.yaml` used when bootstrapping ArgoCD via Helm. It is referenced in the [ArgoCD install guide](/docs/setup/argocd-install-guide.md).

## Notes

### Waves

The inline configmap in `values.yaml` is included to support sync waves.  It was originally copied from the ArgoCD documentation at <https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/#how-do-i-configure-waves>

> **Note:** This configmap may now be unnecessary as it is no longer included in the sync waves guide.

### `values.yaml`

The real `values.yaml` in this directory contains sensitive information.  I included a redacted version for reference.
