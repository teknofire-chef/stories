#
# Cookbook Name:: s2stories
# Recipe:: web
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'chef-vault'
include_recipe 'git'
include_recipe 'postgresql::client'
include_recipe 's2stories::_user'
include_recipe "s2stories::_ruby"
include_recipe "s2stories::_application"
include_recipe "s2stories::_puma"
include_recipe "s2stories::_nginx"
