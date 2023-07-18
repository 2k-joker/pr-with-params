require_relative "../test_helper"

class PRWithParams::ConfigParserTest < Minitest::Test
  def test_that_it_has_valid_frozen_config_keys
    assert_equal(%i[validators base_branch template title labels assignees], PRWithParams::ConfigParser::VALID_CONFIG_KEYS)
    assert_predicate PRWithParams::ConfigParser::VALID_CONFIG_KEYS, :frozen?
  end

  def test_that_it_raises_error_if_file_does_not_exist
    File.stub(:file?, false) do
      assert_raises(PRWithParams::ConfigParser::ParserError, 'Config file path is invalid or file does not exist.') do
        PRWithParams::ConfigParser.new(config_file_path: 'not/file/path.yml').parse!
      end
    end
  end

  def test_that_it_raises_error_if_file_is_not_yaml
    File.stub(:file?, true) do
      assert_raises(PRWithParams::ConfigParser::ParserError, 'Config file type must be YAML (.yaml or .yml)') do
        PRWithParams::ConfigParser.new(config_file_path: 'not/file/path.txt').parse!
      end
    end
  end

  def test_that_it_returns_filtered_defaults_when_default_scope
    @parsed_config = { 'default' => { 'template' => 'default-template', 'bad' => 'foo' }, 'some_scope' => { 'template' => 'custom-template' } }

    File.stub(:file?, true) do
      IO.stub(:read, io_on_read) do
        config = PRWithParams::ConfigParser.new(config_file_path: '/file/path.yml').parse!

        assert_equal({ template: 'default-template' }, config)
      end
    end
  end

  def test_that_it_returns_overrides_default_when_custom_scope
    @parsed_config = { 'default' => { 'template' => 'default-template', 'labels' => 'wip' }, 'some_scope' => { 'template' => 'custom-template' } }

    File.stub(:file?, true) do
      IO.stub(:read, io_on_read) do
        config = PRWithParams::ConfigParser.new(config_file_path: '/file/path.yml', scope: 'some_scope').parse!

        assert_equal({ template: 'custom-template', labels: 'wip' }, config)
      end
    end
  end

  def test_that_it_returns_empty_hash_if_default_or_custom_scope_is_undefined
    @parsed_config = {}

    File.stub(:file?, true) do
      IO.stub(:read, io_on_read) do
        config = PRWithParams::ConfigParser.new(config_file_path: '/file/path.yml', scope: 'some_scope').parse!

        assert_empty(config)
      end
    end
  end

  private

  def io_on_read
    lambda do |file_path|
      raise ArgumentError unless file_path == '/file/path.yml'

      @parsed_config.to_yaml
    end
  end
end
