default['app']['data_bag'] = 'stories'
default['app']['name'] = 'stories'

default['app']['puma_port'] = '8080'
default['app']['gem']['dep_packages'] = []

override['postgresql']['config']['listen_addresses'] = '0.0.0.0'
