ok so here's what i did

started the new postgres 17 server

put it in maintenenec mode

php occ maintenance:mode --on

went to the original postgres database and dumped it

pg_dump -U nextcloud -d nextcloud > /tmp/nextcloud.sql

copied it out

kubectl cp <bitnami-postgres-pod>:/tmp/nextcloud.sql ./nextcloud.sql

turned off maintenance mode in the nextcloud pod

php occ maintenance:mode --off

copied the database dump into the new db pod

kubectl cp ./nextcloud.sql nextcloud-postgresql-test:/tmp/nextcloud.sql

restored the database in the new version (higher version but it figured it out)

psql -U <username> -d nextcloud < /tmp/nextcloud.sql

pointed the helm chart to the new pod

externalDatabase:
  enabled: true
  type: postgresql
  host: nextcloud-postgresql-test-svc  # Your new Service name
  database: nextcloud
  existingSecret:
    enabled: true
    secretName: nextcloud-db-secret
    usernameKey: username
    passwordKey: mariadb-password  # Or whatever key your secret uses

SHOCK!  This is stored in nextclouds config.php which helm doesn't seem to want to rewrite, so i had to go in and edit that manually

vi wasn't installed so i had to use a sed.  did a backup first though

sed -i "s/'dbhost' => '.*'/'dbhost' => 'nextcloud-postgresql-test-svc'/" /var/www/html/config/config.php

recreated the pod and we were good to go

###

then just updated the helm chart to point to the new version

maintenance mode first

update

maintenance mode off

check status, saw new indeces so ran the suggested commands

php occ maintenance:repair --include-expensive

php occ db:add-missing-indices

and then we were good to go!