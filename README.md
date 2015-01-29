# PHP 5.4 for Apache

Tested on:

* Ubuntu  12.04
* Scientific 6.5

Should in theory work on Ubuntu 14LTS and all 6 and 7 rhel family distributions.

On Ubuntu:
Installs PHP 5.4 (from ppa:ondrej/php5) with a lot of extensions, curl and composer.  The recipe is dependent on apache.

On rhel:
Installs PHP 5.4 from the webtatic repository. `node['apache-php54']['elrepository']` is used to set its version. Default is el6.
