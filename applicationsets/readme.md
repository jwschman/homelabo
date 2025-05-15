# applicationsets

This directory Contains the ArgoCD applications that everything used inside the cluster.

- `applicationset.yaml` - ApplicationSet that generates AreoCD applications from all the defined app directories in `apps/`
- `bootstrap.yaml` - App-of-apps that points to everything inside `cluster/`

> **note:** `bootstrap.yaml` is actually type Application despite being in the `applicatoinsets` directory.  To me it makes the most sense to be here despite the name.
