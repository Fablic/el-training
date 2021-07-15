MAINTENANCE_FILE = './tmp/maintenance.yml'.freeze

namespace :maintenance_mode do
  desc 'start maintenance mode'
  task start: :environment do
    File.open(MAINTENANCE_FILE, 'w') unless File.exist?(MAINTENANCE_FILE)
  end

  desc 'end maintenance mode'
  task end: :environment do
    File.delete(MAINTENANCE_FILE) if File.exist?(MAINTENANCE_FILE)
  end
end
