# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'processor'

set :repo_url, 'git@github.com:slonia/processor.git'
set :linked_dirs, fetch(:linked_dirs, []) + %w[log tmp/pids tmp/cache tmp/sockets tmp/processing public/uploads]
set :linked_files, %w[config/database.yml config/secrets.yml]
set :log_level, :info

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
