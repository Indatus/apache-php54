case node['platform_family']
 when 'debian'
include_recipe 'apache-php54::debian'
 when 'rhel'
include_recipe 'apache-php54::rhel'
end 
