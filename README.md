# magentostack
--------------

## Usage

Clone the repository local:

    $ git clone https://github.com/Triple-networks/magentostack.git

Setup the .env-file

    $ cd magentostack
    $ cp .env.dist .env

Create a "personal access token" & add to the .env file

https://github.com/settings/tokens


Do an initial build


    $ sudo docker-compose build


Run docker-compose

    $ sudo docker-compose up -d


Bash into magento

    $ sudo docker-compose run magento bash

In the container:

    $ composer config -g "github-oauth.github.com" "$GITHUB_OAUTH"
    $ composer config -g "http-basic.repo.magento.com" "$MAGENTO_REPO_BASIC_AUTH_USER" "$MAGENTO_REPO_BASIC_AUTH_PASS"


## Setup magento

name: magentostack_web_1



