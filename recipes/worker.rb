#
# Cookbook Name:: s2stories
# Recipe:: worker
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
tag('worker')
app = chef_vault_item('apps', node['app']['data_bag'])

include_recipe 'chef-vault'
include_recipe 'runit'
include_recipe 'git'
include_recipe 'postgresql::client'
include_recipe "s2stories::_user"
include_recipe "s2stories::_ruby"
include_recipe "s2stories::_application"

runit_service "sidekiq" do
  action [:enable, :start]
  log true
  default_logger true
  env({
    "RAILS_ENV" => 'production',
    "PROCESSING_NUMBER_OF_CPUS" => "#{node['cpu']['total']}"
    })

  subscribes :restart, "deploy_revision[#{app['install_path']}]", :delayed
  subscribes :restart, "template[#{app['install_path']}/shared/.env.production]", :delayed
end
