node.default['rubies']['list']                 = ['ruby 2.2.2']
node.default['rubies']['bundler']['install']   = false
node.default['chruby_install']['default_ruby'] = '2.2.2'

include_recipe 'rubies'

%w(erb gem irb rake rdoc ri ruby testrb bundle bundler).each do |rb|
  link "/usr/bin/#{rb}" do
    to "/opt/rubies/ruby-2.2.2/bin/#{rb}"
  end
end

node['app']['gem']['dep_packages'].each do |pkg|
  package pkg
end

gem_package 'bundler' do
  gem_binary '/opt/rubies/ruby-2.2.2/bin/gem'
  version '>= 1.7.3'
end

%w(bundle bundler).each do |rb|
  link "/usr/bin/#{rb}" do
    to "/opt/rubies/ruby-2.2.2/bin/#{rb}"
  end
end
