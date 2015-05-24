#
# Cookbook Name:: s2stories
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
tag('stories')

node.override['chef_client']['init_style'] = 'runit'
include_recipe 'teknobase::default'
