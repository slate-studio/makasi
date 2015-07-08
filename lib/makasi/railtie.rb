module Makasi
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir["#{File.dirname(__FILE__)}/../tasks/*.rake"].sort.each { |ext| load ext }
    end
  end
end
