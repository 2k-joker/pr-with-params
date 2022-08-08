# frozen_string_literal: true

require_relative "../../test_helper"

class PR::With::Params::ConfigParserTest < Minitest::Test
  def test_that_it_has_valid_frozen_config_keys
    assert_equal ::PR::With::Params::ConfigParser::VALID_CONFIG_KEYS, %i[base_branch template title labels assignees]
    assert_predicate ::PR::With::Params::ConfigParser::VALID_CONFIG_KEYS, :frozen?
  end

  def test_that_it_raises_error_if_file_does_not_exist
    File.stub(:file?, false) do
      assert_raises(ArgumentError, 'Config file path is invalid or file does not exist.') do
        ::PR::With::Params::ConfigParser.new(config_file_path: 'not/file/path.yml').parse!
      end
    end
  end

  def test_that_it_raises_error_if_file_is_not_yaml
    File.stub(:file?, true) do
      assert_raises(TypeError, 'Config file type must be YAML (.yaml or .yml)') do
        ::PR::With::Params::ConfigParser.new(config_file_path: 'not/file/path.txt').parse!
      end
    end
  end

  def test_that_it_returns_filtered_defaults_when_default_scope
    @parsed_config = { 'default' => { 'template' => 'default-template', 'bad' => 'foo' }, 'some_scope' => { 'template' => 'custom-template' } }

    File.stub(:file?, true) do
      IO.stub(:read, io_on_read) do
        config = ::PR::With::Params::ConfigParser.new(config_file_path: '/file/path.yml').parse!

        assert_equal config, { :template => 'default-template' }
      end
    end
  end

  def test_that_it_returns_overrides_default_when_custom_scope
    @parsed_config = { 'default' => { 'template' => 'default-template', 'labels' => 'wip' }, 'some_scope' => { 'template' => 'custom-template' } }

    File.stub(:file?, true) do
      IO.stub(:read, io_on_read) do
        config = ::PR::With::Params::ConfigParser.new(config_file_path: '/file/path.yml', scope: 'some_scope').parse!

        assert_equal config, { :template => 'custom-template', :labels => 'wip' }
      end
    end
  end

  private


  def yaml_load_on_call
    ->(file_content) do
      raise ArgumentError unless file_content == @parsed_config.to_yaml

      @parsed_config
    end
  end

  def io_on_read
    ->(file_path) do
      raise ArgumentError unless file_path == '/file/path.yml'

      @parsed_config.to_yaml
    end
  end
end
