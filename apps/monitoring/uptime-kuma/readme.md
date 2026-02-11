# uptime-kuma

## Notes

### Authentik Integration

added following this: <https://docs.goauthentik.io/integrations/services/uptime-kuma/>

because it uses a **Proxy Provider** I needed to add the required annotations to the ingress

```yaml
    nginx.ingress.kubernetes.io/auth-url: |-
       http://ak-outpost-authentik-embedded-outpost.authentik.svc.cluster.local:9000/outpost.goauthentik.io/auth/nginx
    nginx.ingress.kubernetes.io/auth-signin: |-
       https://uptime.pawked.com/outpost.goauthentik.io/start?rd=$escaped_request_uri
    nginx.ingress.kubernetes.io/auth-response-headers: |-
       Set-Cookie,X-authentik-username,X-authentik-groups,X-authentik-email,X-authentik-name,X-authentik-uid
    nginx.ingress.kubernetes.io/auth-snippet: |
       proxy_set_header X-Forwarded-Host $http_host;
```

## 12/18/2025

Migrate ingress to httproute

## 11/6/2025

Change strategy to recreate
