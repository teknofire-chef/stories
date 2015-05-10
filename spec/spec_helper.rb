require 'chefspec'
require 'chefspec/berkshelf'

def configure_chef
  RSpec.configure do |config|
    config.platform = 'Ubuntu'
    config.version = '14.04'
    config.log_level = :error
  end
end

def get_databag_item(name, item)
  filename = File.expand_path(File.join('~/chef/tekno/data_bags', name, "#{item}.json"))
  { item => JSON.parse(IO.read(filename)) }
end

def setup_data_bags(server)
  server.create_data_bag('apps', get_databag_item('apps', 'stories'))
  server.create_data_bag('users', get_databag_item('users', 'webdev'))
end
