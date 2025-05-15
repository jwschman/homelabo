# external-secrets

Contains the helm chart for installing [External Secrets Operator](https://github.com/external-secrets/external-secrets).

## Notes

### `templates/secrets.yaml`

> Due to the way I install things, I don't use External Secrets here to inject its own token.  My actual secrets file contains sensetive credentials and is excluded from this public repository.  I am, however, including a redacted version below and at `templates/vault-backend-redacted.yaml` for reference.

```yaml
### Define the ClusterSecretStore named vault-backend that points to the secret engine used by homelabo
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: <redacted>
      path: <redacted>
      version: "v2"
      auth:
        # points to a secret that contains a vault token
        # https://www.vaultproject.io/docs/auth/token
        tokenSecretRef:
          name: "vault-token"
          key: "token"
          namespace: external-secrets
---
### The token used to authenticate into vault for the vault-backend clustersecretstore
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
  namespace: external-secrets
stringData:
  token: <redacted>
```
