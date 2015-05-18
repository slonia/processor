USER = 'berlin'

worker_processes 2

working_directory "/home/#{USER}/processor/current"

listen "/home/#{USER}/processor/current/tmp/sockets/unicorn.processor.sock", :backlog => 64

pid "/home/#{USER}/processor/current/tmp/pids/unicorn.processor.pid"

preload_app true

stderr_path "/home/#{USER}/processor/current/log/unicorn.stdout.log"
stdout_path "/home/#{USER}/processor/current/log/unicorn.stdout.log"


after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
