require 'httparty'
require 'rails_erd/domain'
require 'rails_erd/diagram'
require 'rails_erd/diagram/graphviz'
require 'domain_generator'
require 'graph_generator'

namespace :du do
  desc 'uploader test'
  task :uploader, [:name, :host] => :environment do |t, args|

    Rails.application.eager_load!
    puts "# Application fully loaded!"

    #domain = DomainGenerator.generate_domain_hash args[:name]
    #puts "# Domain correctly generated!"

    domain_hash = { "project_name" => args[:name] }
    domain = RailsERD::Domain.generate()
    domain_hash.merge!({ "models" => domain.entities.map(&:name) })
    graph = GraphGenerator.generate_graph(domain)
    domain_hash.merge!({ 'graph' => graph })

    HTTParty.post("#{args[:host]}/api/projects_domains/upload_model", {
      :body => domain_hash.to_json,
      #:basic_auth => { :username => api_key },
      :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
    })

    puts "# Done!"
  end


end
