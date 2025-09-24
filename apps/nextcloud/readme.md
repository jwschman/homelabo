# Nextcloud

Nextcloud describes itself as "A safe home for all your data."

My family uses it for file storage in the cloud and automatic photo uploads from our phones.

I also use a couple other integrations.  There are a lot of apps built for Nextcloud, but I specifically want to use it for file storage, syncing, and access.

## My Nextcloud Integrations

- [Paperless-ngx document uploads](https://jwschman.github.io/posts/2025/04-29-paperless-ngx-on-kubernetes-with-nextcloud-integration/)
- [Joplin note syncing](https://joplinapp.org/help/apps/sync/nextcloud/)
- [Cross-browser bookmark syncing with Floccus](https://floccus.org/guides)

I briefly used the News app as an RSS reader, but sought alternatives because it didn't align with my goal of using Nextcloud solely for file storage and syncing.  I don't want to use it as an app platform, so now I use a different RSS aggregator and reader.

## Notes

### using an occ command with nextcloud

`kubectl exec -n nextcloud $NEXTCLOUDPOD -- su -s /bin/sh www-data -c "php occ <command>"`

### Liveness Probes

The readiness and liveness probes in values need to be set to a higher value than defaults for the initial install.  300 seems to be fine.  Return to defaults after initial install.

## Activity Log

### 5/8/2025

changed external secrets to new template
