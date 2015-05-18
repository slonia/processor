USER = 'berlin'

worker_processes 2

working_directory "/home/#{USER}/processing/current"

listen "/home/#{USER}/processing/current/tmp/sockets/unicorn.processing.sock", :backlog => 64

pid "/home/#{USER}/processing/current/tmp/pids/unicorn.processing.pid"

preload_app true

stderr_path "/home/#{USER}/processing/current/log/unicorn.stdout.log"
stdout_path "/home/#{USER}/processing/current/log/unicorn.stdout.log"


after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
