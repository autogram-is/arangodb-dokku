# ArangodDB on Dokku

Most of the existing ArangoDB setup scripts for Dokku assume that you're using it as a
service/plugin for other apps. We needed to use an ArangoDB instance as its own API server,
used by multiple other apps to store/save graph data. In addition, we wanted a single
ArangoDB instance to store multiple databases; Dokku's support for stared storage across
apps isn't there yet.

So here we are. These instructions use an absolute bare bones ArangoDB Dockerfile to spin
up the latest version; the rest is dokku setup.

## Create the app and settings

Create the app, then generate a strong root password for ArangoDB. If you're going to be
sending enormous query results back and forth you can set the NGINX_MAX_REQUEST_BODY config
value to something ridonculous.

```
dokku apps:create arango
dokku config:set --no-restart arango ARANGO_ROOT_PASSWORD=$(echo `openssl rand -base64 45` | tr -d \=+ | cut -c 1-20)
dokku config:set arango NGINX_MAX_REQUEST_BODY=15M
```

## Set up storage

Naturally, you want your data to stick around when ArangoDB reboots. Set up a storage
directory for Arango's DB cruft and mount it.

```
dokku storage:ensure-directory /var/lib/dokku/data/storage/arango
dokku storage:mount arango /var/lib/dokku/data/storage/arango:/var/lib/arangodb3
```

## Pushing the app

On your local machine, clone this repository, add your dokku remote, and push to dokku.

```
git clone <foo bar>
git add remote dokku dokku@your-dokku-server.com:arango
git push dokku
```

## Domain, proxy, and SSL

Setting up a domain may not be necessary if it will live at a subdomain of your global
dokku domain. Set up port mappings so nginx can route things properly; Arango handles
both encrypted and unencrypted traffic on port 8529, so we just point everything there.

```
dokku domains:set arango arango.your-dokku-server.com

dokku ports:add arango http:80:8529
dokku ports:add arango https:443:8529
dokku ports:add arango https:8529:8529

dokku letsencrypt:enable arango
```

At that point, ArangoDB should be accessible at https://arango.your-dokku-server.com.

TBD: clean backups of one or all ArangoDB databases, Foxx microservice definitions, etc.