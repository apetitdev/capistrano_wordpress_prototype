# config valid only for current version of Capistrano
#require 'capistrano/nginx/tasks'

#!/usr/bin/env ruby
require 'dotenv'
Dotenv.load

lock '3.4.0'

set :application, 'investor_relations'
set :repo_url, 'git@github.com:Prepsmith/investor_relations.git'
# set :default_env, { path: "/usr/local/bin:$PATH" }

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git

set :stages, ['dev','staging','production']
set :default_stage, 'dev'

set :ssh_options, {forward_agent: true, paranoid: true, keys: "~/.ssh/id_rsa"}

set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

set :shared_file_backup, false

# Default value for :linked_files is []
set :shared_files,    %w(wp-config.php)

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'db_backup')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :current_path, "/var/www/html/#{fetch(:application)}_#{fetch(:stage)}/"

set :shared_path, "/var/www/html/#{fetch(:application)}_#{fetch(:stage)}/"

set :folder_release, "/var/www/html/#{fetch(:application)}_#{fetch(:stage)}/releases/"


# mysql stuff that is needed to migrate the database during the deployment

set :mysql_db_user, ENV["MY_LOCAL_MYSQL_USER"]

set :mysql_db_host, ENV["MY_LOCAL_MYSQL_HOST"]

set :mysql_db_name, ENV["MY_LOCAL_WP_MYSQL_DB_NAME"]

set :mysql_db_password, ENV["MY_LOCAL_MYSQL_PASSWORD"]

set :adapter, 'mysql'

set :local_port, ENV["MY_LOCAL_PORT"]

set :my_local_address, ENV["MY_LOCAL_ADDRESS"]

set :relative_path_local, ENV["MY_LOCAL_RELATIVE_PATH"]



# let's go for this deployment
namespace :deploy do

  # after :restart, :clear_cache do
  # 	desc "Upload wp-config.php file."
	 #  task :upload_php do
	 #    on roles(:app) do

	 #    end
	 #  end
    # on roles(:web), in: :groups, limit: 3, wait: 10 do
    #   # Here we can do anything such as:
    #   # within release_path do
    #   #   execute :rake, 'cache:clear'
    #   # end
    # end
  # end

  # before :deploy, "db:start"
  # after :deploy, "db:stop"

  after :deploy, 'setup:upload_yml'
  after :deploy, 'setup:symlink_config'
  after :deploy, 'apache:settings'

  # This options has been desactivated because of the use of MAMP of MAC but we need to consider using vagrant for the sake of the development for prepsmith and other projects
  # after :deploy, 'db:dumb_local_db'

  after :deploy, 'db:sanitize_db'
  after :deploy, 'db:inject_my_db'

  # after "deploy:setup", 'nginx:setup', 'nginx:reload'

end
