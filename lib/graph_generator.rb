module GraphGenerator

  def self.generate_graph(domain)
    @graph = []
    domain.entities.each do |entity|
      entity_name = entity.name
      entities = [entity_name]
      entity.relationships.each do |r|
        source = r.source.name
        destination = r.destination.name
        entities.push(source) unless entities.include?(source)
        entities.push(destination) unless entities.include?(destination)
      end
      generate_entity_graph(domain, entity_name, entities)
    end
    @graph
  end

  def self.generate_entity_graph(domain, source, entities)
    diagram = RailsERD::Diagram::Graphviz.new(
      domain,
      { file_type: :dot, only: entities, inheritance: true, disconnected: true }
    )
    diagram.generate
    @graph << { source => diagram.graph.to_s }
  end
end
