#install PHP 5.4
%w(curl libapache2-mod-php5 python-software-properties).each do |pkg|
  package pkg do
    action :install
  end
end

execute "enable_php54_apt_repo" do
  command "add-apt-repository ppa:ondrej/php5 && apt-get update"
  action :run
end



#setup other php stuff
php_packages = [
  "php5",
  "php5-common", 
  "php5-dev", 
  "php5-mysql", 
  "php5-sqlite", 
  "php5-tidy", 
  "php5-xmlrpc", 
  "php5-xsl", 
  "php5-cgi", 
  "php5-mcrypt", 
  "php5-curl", 
  "php5-gd", 
  "php5-memcache", 
  "php5-mhash", 
  "php5-pspell", 
  "php5-snmp", 
  "php5-sqlite", 
  "php5-cli", 
  "php5-imap"
]
php_packages.each do |pkg|
  package pkg do
    action :install
  end
end

# install composer
execute "install_composer" do
  command "curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer"
  action :run
end

#move over the ssl certs if they are present
cookbook_file "/etc/php5/apache2/php.ini" do
  owner "root"
  group "root"
  mode 0644
  action :create_if_missing
  backup 3
end

execute "reload_apache_after_phpini" do
  command "service apache2 reload"
  action :run
end