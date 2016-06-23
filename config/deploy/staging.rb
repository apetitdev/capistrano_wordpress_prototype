# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

#!/usr/bin/env ruby
require 'dotenv'
Dotenv.load

set :stage, :staging
set :branch, "staging"
set :deploy_user, ""
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :server_name, "staging.eiceducation.com"
set :server_ip, ENV['STAGING_ADDRESS']


set :server_wp_db_name, ENV['STAGING_WP_MYSQL_DB_NAME']
set :server_wp_db_hsot, ENV['STAGING_MYSQL_HOST']
set :server_wp_db_user , ENV['STAGING_MYSQL_USER']
set :server_wp_db_password , ENV['STAGING_MYSQL_PASSWORD']
set :server_relative_path_server, ENV['STAGING_RELATIVE_PATH']
set :server_port , ENV['STAGING_PORT']

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '', user: 'deployer', roles: %w{web app db}, port: 22

set :deploy_to, "/var/www/html/#{fetch(:full_app_name)}"

# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
