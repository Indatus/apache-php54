#make an apache service for restarting etc
service "apache2" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end 


%w(curl python-software-properties).each do |pkg|
  package pkg do
    action :install
  end
end


execute "enable_php54_apt_repo" do
  not_if {File.exists?("/etc/apt/sources.list.d/ondrej-php5-precise.list")}
  
  # 2013-07-30, ppa:ondrej/php5 is now installing PHP5.5 which requires Apache2.4 via ppa:ondrej/apache2
  # RE: http://www.justincarmony.com/blog/2013/07/31/ubuntu-12-04-php-5-4-apache2-and-ppaondrejphp5/
  # command "add-apt-repository ppa:ondrej/php5 && apt-get update" 
  
  #use ppa:ondrej/php5-oldstable to get PHP5.4 for ubuntu 12.04.2
  command "add-apt-repository ppa:ondrej/php5-oldstable && apt-get update"

  action :run
end



#install PHP 5.4
php_packages = [
  "libapache2-mod-php5",
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
  not_if { File.exists?("/usr/local/bin/composer") }
  command "curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer"
  action :run
end

if node[:php][:install_xdebug] == true

  #download and extract xdebug source
  execute "xdebug_download_source" do
    not_if { File.exists?("/usr/src/xdebug-#{node[:php][:xdebug_version]}") }
    command <<-EOH
      wget http://xdebug.org/files/xdebug-#{node[:php][:xdebug_version]}.tgz -O /usr/src/xdebug-#{node[:php][:xdebug_version]}.tgz &&
      cd /usr/src/ && tar -zxf xdebug-#{node[:php][:xdebug_version]}.tgz   
    EOH
    action :run
  end

  #compile xdebug source
  execute "xdebug_compile_source" do
    not_if { File.exists?("/usr/src/xdebug-#{node[:php][:xdebug_version]}/modules/xdebug.so") }
    command "cd /usr/src/xdebug-#{node[:php][:xdebug_version]} && phpize && ./configure && make"
    action :run
  end

  #copy xdebug module
  execute "xdebug_copy_module" do
    command <<-EOH
      (cd /usr/src/xdebug-#{node[:php][:xdebug_version]} && phpize | grep "Zend\ Module" | sed 's/[^0-9]*//g' > /tmp/phpize_version.txt)
      (cp /usr/src/xdebug-#{node[:php][:xdebug_version]}/modules/xdebug.so /usr/lib/php5/`cat /tmp/phpize_version.txt`/)    
    EOH
    action :run
  end

end #end if xdebug


#write out the php.ini file
template "/etc/php5/apache2/php.ini" do
  source "php.ini.erb"
  notifies :restart, "service[apache2]"
end