# Authentik

## HomeLABO Integrations

| App | Enabled? | Note |
|---|---|---|
| ArgoCD | ❓ | Still considering if I should enable it |
| Linkwarden | ✅ | Integrated using OAuth2 |
| Grafana | ❌ | Not implemented yet |
| Uptime-kuma | ✅ | Integrated using Proxy Provider |
| Nextcloud | ❓ | Also wondering if I should enable |
| Paperless | ✅ | Integrated using OAuth2 |
| Redmine | ❌ | Not yet... might be a hassle from what I've seen online |
| Wordpress | ❌ | Not implemented yet |
| Hashicorp Vault | ❓ | Not sure if it makes sense to set this up with Authentik |
| TrueNAS | ❌ | Not really supported on TrueNAS Core, but maybe I can find a workaround (or finally update to SCALE) |

**Legend:**  
✅ = Enabled  
❌ = Not enabled  
❓ = Undecided  

## Activity Log

### 5/14/2025

Started integrating apps with Authentik as I use them.  The guides on the [official integrations overview](https://docs.goauthentik.io/integrations/) page have been mostly helpful, but some of them require a little bit of extra research and configuration.

## Notes

### Installation and setup

I followed the [official docs](https://docs.goauthentik.io/docs/install-config/install/kubernetes) for installation and [this guide](https://surajremanan.com/posts/authentik-with-kubernetes-forward-auth/) for initial setup and testing.

### `values.yaml` and secrets

Setting up the values was a little difficult because the official helm chart does not include the standard existingSecret for secrets.  After playing around with it a little while I noticed how secrets were handled on the ***"Advanced values examples"*** on the [artifacthub page](https://artifacthub.io/packages/helm/goauthentik/authentik).  Following that example I was able to just make my external secrets as usual and mount the secrets file as a volume in the pods.

### Initial Login Troubles

After initial setup I should have just been able to go to <https://auth.pawked.com/if/flow/initial-setup/> but I was getting 404d.  After a little research online I saw people recommending restarting the server.  Seems like a weird fix, but it worked.

## References

- <https://docs.goauthentik.io/docs/install-config/install/kubernetes>
- <https://artifacthub.io/packages/helm/goauthentik/authentik>
- <https://surajremanan.com/posts/authentik-with-kubernetes-forward-auth/>
