#!/usr/bin/env bash
echo "syncing"
rsync -au /var/wwww/vendor /var/www/vendor
echo "synced, changing permissions"
chown -R laradock:laradock /var/www
echo "Done."
