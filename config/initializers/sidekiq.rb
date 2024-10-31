require 'sidekiq/scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq::Scheduler.enabled = true
    Sidekiq::Scheduler.dynamic = true
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq.yml', __dir__))
    Sidekiq::Scheduler.reload_schedule!
  end
end
