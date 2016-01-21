module DomainGenerator
  def self.generate_domain_hash name
    domain = {"project_name" => name, "models" => {}, "relationships" => []}
    ActiveRecord::Base.descendants.each do |model|
      unless /pgsearch/.match(model.name.downcase)
        domain["models"][model.name] = { "columns" => {} }
        model.columns.each{ |c| domain["models"][model.name]["columns"].merge!({c.name => c.sql_type}) }
        model.reflect_on_all_associations.each do |relationship|
          domain["relationships"].concat parse_relationship(relationship)
        end
      end
    end
    domain
  end

  def self.parse_relationship relationship
    dependencies = polymorphic_dependencies(relationship)
    generate_relationships(relationship, dependencies)
  end

  REL_HASH = -> relationship, dependency {
    {
      "left_model" => parse_active_record(relationship.active_record),
      "right_model" => parse_active_record(dependency),
      "rel_type" => relationship.macro,
      "name" => relationship.name,
      "options" => parse_rel_options(relationship)
    }
  }
  def self.generate_relationships relationship, dependencies=nil
    hash_for_relationship = REL_HASH.curry[relationship]
    (dependencies || [relationship.klass]).map(&hash_for_relationship)
  end

  def self.parse_rel_options relationship
    # opts = relationship.options
    # opts[:class_name] = parse_active_record(opts[:class_name]) if opts[:class_name].present?
    # opts
    relationship.options.tap{ |opts|
      class_name = opts[:class_name]
      opts[:class_name] = parse_active_record(class_name) if class_name
    }
  end

  def self.parse_active_record active_record
    active_record.to_s.gsub(/\(.+\)/, '')
  end

  def self.polymorphic_dependencies relationship
    return nil unless relationship.options[:polymorphic]
    ActiveRecord::Base.descendants.select { |model| polymorphic_match?(relationship,model) }
  end

  def self.polymorphic_match? relationship, model
    model.reflect_on_all_associations(:has_many).any? do |has_many_association|
      has_many_association.options[:as] == relationship.name
    end
  end
end
