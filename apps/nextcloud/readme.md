# Nextcloud

## Notes

### using an occ command with nextcloud

`kubectl exec -n nextcloud $NEXTCLOUDPOD -- su -s /bin/sh www-data -c "php occ <command>"`

### Liveness Probes

The readiness and liveness probes in values need to be set to a higher value than defaults for the initial install.  300 seems to be fine.  Return to defaults after initial install.

---

## Activity Log

### 5/8/2025

changed external secrets to new template
