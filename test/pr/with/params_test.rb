# frozen_string_literal: true

require_relative "../../test_helper"

class PR::With::ParamsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PR::With::Params::VERSION
  end

  def test_that_it_open_the_expected_url
    URI.stub(:encode_www_form, uri_mock_on_encode_www_form) do
      URI::HTTPS.stub(:build, uri_https_mock_on_build) do
        Launchy.stub(:open, launchy_mock_on_open) do
          @host = 'www.example.com'
          @path = '/path/to/freedom'
          @query = { url_query: 'string' }
          
          assert ::PR::With::Params.open(host: @host, path: @path, query: @query)
        end
      end
    end
  end

  def test_that_it_returns_the_expected_config_if_no_error
    assert_equal ::PR::With::Params.parse_config('', nil), {}
  end

  def test_that_it_returns_the_expected_config_if_file_path_is_empty
    ::PR::With::Params::ConfigParser.stub(:new, @raised_error) do
      @file_path = '/path/to/config.yml'
        @scope = 'feature'
  
        assert_equal ::PR::With::Params.parse_config(@file_path, @scope), {}
    end
  end

  def test_that_it_returns_the_expected_config_if_error
    @raised_error = ->(_options) { raise TypeError.new('Not my type') }

    ::PR::With::Params::ConfigParser.stub(:new, @raised_error) do
      @file_path = '/path/to/config.yml'
        @scope = 'feature'
  
        assert_equal ::PR::With::Params.parse_config(@file_path, @scope), {}
    end
  end

  private

  def uri_mock_on_encode_www_form
    ->(query_hash) do
      raise ArgumentError unless query_hash == @query

      'url_query=string'
    end
  end

  def uri_https_mock_on_build
    ->(options) do
      raise ArgumentError unless options[:host] == @host && options[:path] == @path && options[:query] == 'url_query=string'

      'https//www.example.com?url_query=string'
    end
  end

  def launchy_mock_on_open
    ->(url_arg) do
      raise ArgumentError unless url_arg == 'https//www.example.com?url_query=string'
      puts 'Url correctly opened!'
      true
    end
  end

  def config_parser_on_new
    ->(options) do
      raise ArgumentError unless options[:config_file_path] == @file_path && options[:scope] == @scope

      @config_parser_mock
    end
  end
end
