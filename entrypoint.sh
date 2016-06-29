#!/usr/bin/env bash

set -e

# Empty apache2 logs directory
if [ -d /var/log/apache2 ]; then
    echo "cleanup apache2 logs"
    rm -rf /var/log/apache2/*.log
fi

# Empty supervisor logs directory
if [ -d /var/log/supervisor ]; then
    echo "cleanup supervisord logs"
    rm -rf /var/log/supervisor/*.log
fi

composer config -g "github-oauth.github.com" "$GITHUB_OAUTH"

# Start services
echo "Start magentostack"

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
