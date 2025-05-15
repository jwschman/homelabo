# apps

Contains all manifests and charts referenced by `applicationsets/applicationset.yaml`

Each top-level folder under `apps/` becomes its own Kubernetes namespace as defined by the ApplicationSet. Any apps inside those folders are deployed into that same namespace.

Many subdirectories have a `readme.md` that contains my general notes about the app as well as activity logs and any other information I found helpful or necessary.
