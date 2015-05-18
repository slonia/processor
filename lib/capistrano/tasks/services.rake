[:unicorn, :sidekiq].each do |serv|
  namespace serv do

    [:stop, :start, :restart]. each do |action|
      desc 'Performs #{action.to_s} on #{serv}'
      task action do
        on roles(:app) do
          execute "sv #{action.to_s} processor_#{serv.to_s} "
        end
      end
    end

  end
end
