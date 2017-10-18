class Chef
  class Recipe
    # Helper methods for the `newrelic-infra` cookbook recipes
    #
    # @since 0.1.0
    module NewRelicInfra
      class << self
        # Method to generate a String of configuration flags from a given hash
        #
        # @param flags [Hash] hash of configuration flags and associated values
        # @return [String] string of configuration flags and associated values
        def generate_flags(flags)
          flag_arr = flags.each_with_object([]) do |(flag_key, flag_value), obj|
            obj << "-#{flag_key}=#{flag_value}" unless flag_value.nil?
          end
          flag_arr.join(' ')
        end

        # Method to modify YAML files to generate files that are compatiable with the New Relic
        # Infrastructure agent. Currently, the agent's Go library for parsing YAML files
        # does not conform to YAML spec. Thus, nested lists would have 2 spaces before
        # each element in the list.
        #
        # @since 0.3.0
        # @author Trevor G. Wood
        # @param current_contents [String] generated YAML file string
        # @return [String] YAML file with nested lists modifed
        def yaml_file_workaround(current_contents)
          nested_map = current_contents[/^\-\s\w+:/] ? true : false
          regex = nested_map ? /^(\-?\s+)/ : /^(\s+\-\s)/
          current_contents.delete!('"')
          current_contents.gsub!(regex, '  \\1')
          current_contents
        end
      end
    end
  end
end

# Adds a method to Hash class types to recursively string-ify all keys
class Hash
  def deep_stringify
    each_with_object({}) do |(key, value), options|
      deep_val =
        if value.is_a? Hash
          value.deep_stringify
        elsif value.is_a? Array
          value.map do |arr|
            arr.is_a?(Hash) ? arr.deep_stringify : arr
          end
        else
          value
        end

      options[key.to_s] = deep_val
    end
  end

  def delete_blank
    delete_if do |_, value|
      (value.respond_to?(:empty?) ? value.empty? : !value) || value.instance_of?(Hash) && value.delete_blank.empty?
    end
  end
end
# rubocop:enable Metrics/MethodLength
