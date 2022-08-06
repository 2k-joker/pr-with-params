# frozen_string_literal: true

require_relative "../../test_helper"

class PR::With::ParamsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PR::With::Params::VERSION
  end

  def test_it_does_something_useful
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
end
