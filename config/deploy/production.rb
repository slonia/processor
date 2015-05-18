server '95.85.49.5', user: 'berlin', roles: [:app, :web, :db], primary: true

set :stage, :production
set :rails_env, :production
set :deploy_to, '/home/berlin/processor'
