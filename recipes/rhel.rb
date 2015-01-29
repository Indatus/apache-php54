#make an apache service for restarting etc
service "httpd" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end

execute "install_webtatic_repo" do
  not_if {File.exists?("/etc/yum.repos.d/webtatic.repo")}
  command "yum install -y #{node['apache-php54']['elrepository']}"
  action :run
end

node['apache-php54']['packages'].each do |pkg|
    package pkg
end

node['apache-php54']['extrapackages'].each do |pkg|
    package pkg
end

execute "install_xdebug" do 
   command "yum install -y php54w-pecl-xdebug"
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
template "/etc/php.ini" do
  source "php.ini.erb"
  notifies :restart, "service[httpd]"
end
