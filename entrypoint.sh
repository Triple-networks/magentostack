#!/usr/bin/env bash

set -eo pipefail


INSTALL_SCRIPT=resetdevelopment.sh

# if not additional instructions are send
if [ "$1" = '/usr/bin/supervisord' -a "$2" = '-c' -a "$3" = '/etc/supervisor/supervisord.conf' ]; then


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



    # Empty supervisor logs directory
    if [ ! -d "${PROJECT_PATH}" ]; then

        if [ -z "$GITHUB_OAUTH" ]; then

            git clone -b "${PROJECT_BRANCH}" --single-branch "https://${PROJECT_REPOSITORY}" "${PROJECT_PATH}"
            cd "${PROJECT_PATH}"
        else
            git clone -b "${PROJECT_BRANCH}" --single-branch "https://${GITHUB_OAUTH}:x-oauth-basic@${PROJECT_REPOSITORY}" "${PROJECT_PATH}"
            cd "${PROJECT_PATH}"
            git remote set-url origin "https://${PROJECT_REPOSITORY}"
            composer config -g "github-oauth.github.com" "${GITHUB_OAUTH}"
        fi





        # Empty supervisor logs directory
        if [ -f "${PROJECT_PATH}/${INSTALL_SCRIPT}" ]; then
            /bin/sh -c "${PROJECT_PATH}/${INSTALL_SCRIPT}"
        fi

    else

        # prevent unwanted deleting
        echo ""
        echo ""
        echo ""
        echo "directory already exists!"
        echo ""
        echo ""
        echo ""
        echo ""
        echo ""
        echo ""

    fi

    # Start services
    echo "Start magentostack"

fi

exec "$@"
