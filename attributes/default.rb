default['apache-php54']['install_xdebug'] = false
default['apache-php54']['xdebug_version'] = "2.2.3"
default['apache-php54']['packages'] = case node['platform_family']
when 'debian'
  %w(
    libapache2-mod-php5
    php5
    php5-common
    php5-dev
    php5-mysqlnd
    php5-tidy
    php5-sqlite
    php5-tidy
    php5-xmlrpc
    php5-xsl
    php5-cgi
    php5-mcrypt
    php5-curl
    php5-gd
    php5-memcache
    php5-pspell
    php5-snmp
    php5-sqlite
    php5-cli
    php5-imap
    php5-ldap
  )
when 'rhel'
  %w(
    php54w
    php54w-cli
    php54w-common
    php54w-devel
    php54w-gd
    php54w-imap
    php54w-ldap
    php54w-mbstring
    php54w-mcrypt
    php54w-mysqlnd
    php54w-odbc
    php54w-pdo
    php54w-pear
    php54w-pecl-imagick
    php54w-pecl-memcache
    php54w-pecl-memcached
    php54w-pecl-redis
    php54w-process
    php54w-pspell
    php54w-snmp
    php54w-soap
    php54w-tidy
    php54w-xml
    php54w-xmlrpc
    libxslt
    libxslt-devel
    )
end
default['apache-php54']['extrapackages']= case node['platform_family']
when 'debian'
  %w(
    curl
    python-software-properties
  )
when 'rhel'
  %w(
    curl
    )
end
default['apache-php54']['elrepository']= 'https://mirror.webtatic.com/yum/el6/latest.rpm'
