if defined?(ChefSpec)
  ChefSpec.define_matcher :create_newrelic_infra_integration
  def create_newrelic_infra_integration(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:newrelic_infra_integration, :create, resource_name)
  end

  ChefSpec.define_matcher :remove_newrelic_infra_integration
  def remove_newrelic_infra_integration(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:newrelic_infra_integration, :remove, resource_name)
  end
end
