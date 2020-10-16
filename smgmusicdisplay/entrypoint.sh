#!/usr/bin/env bash
echo "syncing"
rsync -au /var/wwww/ /var/www
echo "synced, changing permissions"
chown -R laradock:laradock /var/www
echo "Done."
