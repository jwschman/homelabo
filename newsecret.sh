#!/bin/bash

secretname=$(printf '%s' 'Enter Name of Secret in Vault: ' >&2; read x && printf '%s' "$x")
secretnamespace=$(printf '%s' 'Enter Desired Kubernetes Namespace: ' >&2; read x && printf '%s' "$x")

cat << EOF > externalsecret.yaml
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
    name: $secretname-externalsecret        # arbitrary name of this externalsecret resource
    namespace: $secretnamespace             # the namespace to put the secret in
spec:
    refreshInterval: "1h"
    secretStoreRef:
        name: vault-backend
        kind: ClusterSecretStore
    target:
        name: $secretname-secrets           # the name of the secret that's going to be made in kubernetes in the defined namespace
        creationPolicy: Owner
    dataFrom:
    - extract:
        key: $secretname                    # the name of the vault secret to pull data from
        conversionStrategy: Default
        decodingStrategy: None
        metadataPolicy: None
EOF