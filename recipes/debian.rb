#make an apache service for restarting etc
service "apache2" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end

node['apache-php54']['extrapackages'].each do |pkg|
    package pkg
end

execute "enable_php54_apt_repo" do
  not_if {File.exists?("/etc/apt/sources.list.d/ondrej-php5-oldstable-precise.list")}

  # 2013-07-30, ppa:ondrej/php5 is now installing PHP5.5 which requires Apache2.4 via ppa:ondrej/apache2
  # RE: http://www.justincarmony.com/blog/2013/07/31/ubuntu-12-04-php-5-4-apache2-and-ppaondrejphp5/
  # command "add-apt-repository ppa:ondrej/php5 && apt-get update"

  #use ppa:ondrej/php5-oldstable to get PHP5.4 for ubuntu 12.04.2
  command "add-apt-repository ppa:ondrej/php5-oldstable && apt-get update"

  action :run
end

node['apache-php54']['packages'].each do |pkg|
    package pkg
end

execute "install_xdebug" do
    command "apt-get install -y php5-xdebug"
    action :run
    only_if { node['apache-php54']['install_xdebug'] == 'true' }
end

# install composer
execute "install_composer" do
  not_if { File.exists?("/usr/local/bin/composer") }
  command "curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer"
  action :run
end

#write out the php.ini file
template "/etc/php5/apache2/php.ini" do
  source "php.ini.erb"
  notifies :restart, "service[apache2]"
end
