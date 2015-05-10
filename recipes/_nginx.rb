node.override['nginx']['default_site_enabled'] = false
node.override['nginx']['repo_source'] = 'nginx'
# node.override['nginx']['source']['modules'] = ['http_ssl_module.rb']
include_recipe 'nginx'

certificate_manage "nginx" do
  cert_path "/etc/nginx/ssl"
  data_bag_type "vault"
  search_id node['app']['ssl_data_bag']
  owner "nginx"
  group "nginx"
  cert_file "#{node['app']['name']}.pem"
  key_file "#{node['app']['name']}.key"
  nginx_cert true
  only_if { node['app'].attribute?('ssl_data_bag') }
end

app = chef_vault_item('apps', node['app']['data_bag'])

ruby_block 'move_nginx_confs' do
  block do
    if File.exists? '/etc/nginx/conf.d'
      FileUtils::rm_rf '/etc/nginx/conf.d'
    end
  end
end

template "/etc/nginx/sites-available/#{node['app']['name']}" do
  source 'nginx_site.erb'
  variables({
    install_path: "#{app['install_path']}/current",
    name: node['app']['name'],
    environment: node['app']['environment'],
    port: node['app']['puma_port'],
    enable_ssl: node['app'].attribute?('ssl_data_bag'),
    ssl_cert: "ssl/certs/#{node['app']['name']}.pem",
    ssl_key: "ssl/private/#{node['app']['name']}.key"
  })
  notifies :restart, "service[nginx]", :delayed
end

nginx_site node['app']['name']
