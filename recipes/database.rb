#
# Cookbook Name:: s2stories
# Recipe:: database
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
tag('stories-database')


include_recipe 'chef-vault'

app = chef_vault_item('apps', node['app']['data_bag'])

node.default['postgresql']['pg_hba'] += [{
	:type => 'host',
	:db => app['db']['name'],
	:user => app['db']['username'],
	:addr => 'all',
	:method => 'trust'
},{
  :type => 'host',
  :db => 'postgres',
  :user => app['db']['username'],
  :addr => 'all',
  :method => 'trust'
}]

include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

postgresql_connection_info = {
	host: '127.0.0.1',
	port: 5432,
	username: 'postgres'
}

# create a postgresql database
postgresql_database app['db']['name'] do
  connection postgresql_connection_info
  action :create
end

# Create a postgresql user but grant no privileges
postgresql_database_user app['db']['username'] do
  connection postgresql_connection_info
  password   app['db']['password']
  action     :create
end

# Grant all privileges on all tables in foo db
postgresql_database_user app['db']['username'] do
  connection    postgresql_connection_info
  database_name  app['db']['name']
  privileges    [:all]
  action        :grant
end
