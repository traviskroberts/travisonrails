require "bundler/capistrano"

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# The name of your application. Used for directory and file names
set :application, "travisonrails"

# Target directory for the application on the web and app servers.
set :deploy_to, "/var/www/apps/#{application}"

# Primary domain name of your application. Used as a default for all server roles.
set :domain, "travisonrails.com"

# Login user for ssh.
set :user, "deploy"
set :use_sudo, false

# =============================================================================
# ROLES
# =============================================================================
# Modify these values to execute tasks on a different server.
role :web, domain
role :app, domain
role :db,  domain, :primary => true

# =============================================================================
# SCM OPTIONS
# =============================================================================
set :scm, :git
set :repository, "git@github.com:travisr/tor_blog.git"
set :branch, :master

# =============================================================================
# CAPISTRANO OPTIONS
# =============================================================================
set :keep_releases, 3
set :deploy_via, :remote_cache

# action to symlink database file
namespace :deploy do
  desc "Symlink database config file."
  task :symlink_db do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_db'
after 'deploy:symlink', 'deploy:cleanup'
