#!/usr/bin/env bash

set -e


INSTALL_SCRIPT=resetdevelopment.sh

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


echo "git clone -b ${PROJECT_BRANCH} --single-branch https://${GITHUB_OAUTH}:x-oauth-basic@${PROJECT_REPOSITORY} ${PROJECT_PATH}"

git clone -b "${PROJECT_BRANCH}" --single-branch "https://${GITHUB_OAUTH}:x-oauth-basic@${PROJECT_REPOSITORY}" "${PROJECT_PATH}"

cd "${PROJECT_PATH}"

git remote set-url origin "https://${PROJECT_REPOSITORY}"

composer config -g "github-oauth.github.com" "${GITHUB_OAUTH}"


# Empty supervisor logs directory
if [ -f "${PROJECT_PATH}/${INSTALL_SCRIPT}" ]; then
    /bin/sh -c "${PROJECT_PATH}/${INSTALL_SCRIPT}"
fi


# Start services
echo "Start magentostack"

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
