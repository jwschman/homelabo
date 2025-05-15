# redis

## Notes

### Centralized Redis Instance

I noticed that I was running three separate instances of Redis and decided to consolidate them to a central instance to save a bit of resources.  It's not a big deal, but saves a little on overhead.

|App|Enabled?|
|-|-|
|Authentik|✅|
|Nextcloud|❌|
|Paperless-ngx|❌|
