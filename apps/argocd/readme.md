# argocd

## Activity Log

### 5/8/2025

Switched the admin credentials from helm to external secrets.  Set helm to not create the `argocd-secret` object, and just pulled in a secret from vault that contained `admin.password` and `admin.passwordMtime` as well as the previous `server.secretkey`.

### 5/2/2025

Started working on adding the homelabo github repo to the secrets.  There are some test ones still in there that need to be pulled out, but at least its working as expected.

Here's the format:

```json
  "name": "homelabo",
  "sshPrivateKey": <key contents>,
  "type": "git",
  "url": "git@github.com:jwschman/homelabo"
```

then I just had to add `argocd.argoproj.io/secret-type: repository` to the label of the secret

I put that into an external secret in vault and was good to go.

Next will be switching over the admin username secrets

### 4/11/2025

Since I've been changing deployments to use Recreate rather than RollingUpdate I decided to do the same for ArgoCD.  That was a bit harder than originally planned.  Since Argo manages itself, and if you try to delete some of those old deployments (since you can't change recreation strategy in a live deployment) argo won't just reapply the configs since, you know, it's down.  That was... interesting.

The easy way to fix this was to just reapply the argocd init (also with recreation strategy set to recreate) and have argocd pick everything back up, including itself.
