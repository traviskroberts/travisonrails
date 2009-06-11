require 'railsmachine/recipes'

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# The name of your application. Used for directory and file names
set :application, "tor_blog"

# Target directory for the application on the web and app servers.
set :deploy_to, "/var/www/apps/#{application}"

# Primary domain name of your application. Used as a default for all server roles.
set :domain, "travisonrails.com"

# Login user for ssh.
set :user, "deploy"
set :runner, user
set :admin_runner, user

# Rails environment. Used by application setup tasks and migrate tasks.
set :rails_env, "production"

# =============================================================================
# ROLES
# =============================================================================
# Modify these values to execute tasks on a different server.
role :web, domain
role :app, domain
role :db,  domain, :primary => true
role :scm, domain

# =============================================================================
# APPLICATION SERVER OPTIONS
# ============================================================================= 
set :app_server, :passenger  # :mongrel or :passenger

# =============================================================================
# WEB SERVER OPTIONS
# =============================================================================
# set :httpd, "apache"   # apache 
# set :apache_server_name, domain
# set :apache_server_aliases, %w{alias1 alias2}
# set :apache_default_vhost, true # force use of  apache_default_vhost_config
# set :apache_default_vhost_conf, "/etc/httpd/conf/default.conf"
# set :apache_conf, "/etc/httpd/conf/apps/#{application}.conf"
# set :apache_proxy_port, 8000
# set :apache_proxy_servers, 2
# set :apache_proxy_address, "127.0.0.1"
# set :apache_ssl_enabled, false
# set :apache_ssl_ip, "127.0.0.1"
# set :apache_ssl_forward_all, false
# set :apache_ctl, "/etc/init.d/httpd"

# =============================================================================
# DATABASE OPTIONS
# =============================================================================
set :database, "mysql"   # mysql or postgresql

# =============================================================================
# SCM OPTIONS
# =============================================================================
set :scm, :git
set :repository, "git@github.com:travisr/#{application}.git"

# =============================================================================
# CAPISTRANO OPTIONS
# =============================================================================
set :keep_releases, 5
set :deploy_via, :remote_cache
