#
# Cookbook Name:: s2stories
# Recipe:: redis
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
tag('stories-redis')

include_recipe "redisio::default"
include_recipe "redisio::enable"
