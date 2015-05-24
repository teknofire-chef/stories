app = chef_vault_item('apps', node['app']['data_bag'])

package 'imagemagick'

['', 'shared', 'shared/bundle'].each do |subdir|
  Chef::Log.info "Attempting to create #{File.join(app['install_path'], subdir)}"
  directory File.join(app['install_path'], subdir) do
    user 'webdev'
    group 'webdev'
    mode 0755
    recursive true
    action :create
  end
end


database_host = ''
unless Chef::Config[:solo]
  database_host = search(:node, 'tags:stories-database', filter_result: {'ip' => ['ipaddress']})
end
database_host  = [{'ip' => node['ipaddress']}] if database_host.empty?

template "#{app['install_path']}/shared/.env.production" do
  source "env.erb"
  user 'webdev'
  group 'webdev'

  variables({env: app['env'].merge({
     rails_database_host: database_host.first['ip'],
     rails_database_user: app['db']['username'],
     rails_database_password: app['db']['password'],
     path: "$PATH:#{app['install_path']}/current/bin"
   })
  })
end

include_recipe 'nodejs'

deploy_revision app['install_path'] do
  repo app['repository']
  revision app['revision']
  user 'webdev'
  group 'webdev'
  migrate true
  migration_command 'bundle exec rake db:migrate'
  environment 'RAILS_ENV' => 'production'
  action app['deploy_action'] || 'deploy'

  symlink_before_migrate({
    '.env.production' => '.env',
    'tmp' => 'tmp'
  })

  before_migrate do
    %w(pids log system public tmp).each do |dir|
      directory "#{app['install_path']}/shared/#{dir}" do
        mode 0755
        recursive true
      end
    end

    template "#{release_path}/config/database.yml" do
      variables(app: app)
    end

    execute 'bundle install' do
      cwd release_path
      user 'webdev'
      group 'webdev'
      command "bundle install --deployment --without \"development test\" --path=#{app['install_path']}/shared/bundle"
      # environment({"BUNDLE_BUILD__PG" => "--with-pg_config=/usr/pgsql-#{node['postgresql']['version']}/bin/pg_config"})
    end
  end

  before_restart do
    execute 'assets:precompile' do
      user 'webdev'
      group 'webdev'
      environment 'RAILS_ENV' => 'production'
      cwd release_path
      command 'bundle exec rake assets:precompile'
      only_if { app['precompile_assets'] }
    end
  end

  after_restart do
    execute 'chown-release_path-assets' do
      command "chown -R webdev:webdev #{release_path}/public/assets"
      user 'root'
      action :run
      only_if { ::File.exists? "#{release_path}/public/assets"}
    end
  end
end
