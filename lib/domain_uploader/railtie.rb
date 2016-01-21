require 'domain_uploader'
require 'rails'
module DomainUploader
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'lib/tasks/uploader.rb'
    end
  end
end
