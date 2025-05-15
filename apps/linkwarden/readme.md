# linkwarden

## References

- <https://www.bentasker.co.uk/posts/documentation/kubernetes/deploying-linkwarden-into-a-k8s-cluster.html>

## Notes

### Longhorn Volumes with PostgreSQL

postgres didn't like the volumemount just being a longhorn volume because of the `lost+found` directory

fixed by mounting it as usual, but setting the postgres env PGDATA to a subdirectory in that mount path

### Init Container

added an init container as well to wait for postgres because Linkwarden was just crashing if it didn't see postgres right away

### Setting up authentik

I initially followed this guide: <https://docs.goauthentik.io/integrations/services/linkwarden/>

Setting the redirect URI the way they specified did not work.

Then I found this guide directly by linkwarden: <https://docs.linkwarden.app/self-hosting/sso-oauth#authentik>

They said to leave the redirect URI blank and that it would be populated after being used once.  And that worked.

I'm also pretty sure it populated with exactly the same thing I was entering, but whatever.
