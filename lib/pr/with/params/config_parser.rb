require 'yaml'

module PR
  module With
    module Params
      class ConfigParser
        # Attributes
        attr_reader :config_file_path, :scope, :parsed_config, :filtered_config

        # Constants
        VALID_CONFIG_KEYS = %i[base_branch template title labels assignees].freeze

        def initialize(config_file_path:, scope: nil)
          @config_file_path = config_file_path
          @scope = scope&.to_sym || :default
        end

        def parse!
          validate_file_type!
          parse_yaml_config
        end

        private

        def parse_yaml_config
          @parsed_config = YAML::load(IO.read(config_file_path)).transform_keys(&:to_sym)
          @filtered_config = scoped_config.transform_keys(&:to_sym).slice(*VALID_CONFIG_KEYS)
        end

        def scoped_config
          if scope == :default || parsed_config.fetch(scope, {}).empty?
            parsed_config.fetch(:default, {})
          else
            parsed_config.fetch(:default, {}).merge(parsed_config[scope])
          end
        end

        def validate_file_type!
          raise TypeError.new('Config file type must be YAML (.yaml or .yml)') unless yaml_file?
          raise ArgumentError.new("Config file path is invalid or file does not exist: #{config_file_path}") unless file_exists?
        end

        def yaml_file?
          config_file_path.end_with?('.yaml') || config_file_path.end_with?('yml')
        end

        def file_exists?
          File.file?(config_file_path)
        end
      end
    end
  end
end
