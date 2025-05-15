# Longhorn

## Notes

### Longhorn Volume Boilerplate

There is a volume boilerplate at `boilerplates/storage.yaml` to be used for declaring longhorn volumes.

### Blacklisting devs for multipathd

need to disable multipathd on the nodes, or add this to /etc/multipath.conf

```bash
blacklist {
    devnode "^sd[a-z0-9]+"
}
```

then run:

`systemctl restart multipathd.service`

taken from this page:

<https://longhorn.io/kb/troubleshooting-volume-with-multipath/>

### Full restore

I'm still working on figuring out how to restore everything in longhorn from backups, but I have made some progress with backup images.  Longhorn automatically detects them from the backup server and can pull them in if detected.  I just need to do a test run of a full restore to check that everything is working.
