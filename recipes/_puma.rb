#
# Cookbook Name:: gina_id
# Recipe:: _runit
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'runit'

app = chef_vault_item('apps', node['app']['data_bag'])

node.run_state['app_install_path'] = app['install_path']

runit_service 'puma' do
  action [:enable, :start]
  log true
  default_logger true
  options({
    release_path: "#{app['install_path']}/current"
  })
  env({
    "RAILS_ENV" => 'production',
    "PORT" => node['app']['puma_port'],
    "PUMA_APP_PATH" => "#{app['install_path']}/current",
    "PUMA_PIDFILE" => "#{app['install_path']}/shared/pids/puma.pid"
  })

  subscribes :usr2, "deploy_revision[#{app['install_path']}]", :delayed
  subscribes :usr2, "template[#{app['install_path']}/shared/.env.production]", :delayed
end
