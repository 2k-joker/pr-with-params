# frozen_string_literal: true

require_relative "params/version"
require 'uri'

module Pr
  module With
    module Params
      class Error < StandardError; end
      
      def self.build_url_string(host:, path:, query:)
        uri_query = URI.encode_www_form(query)
        uri = URI::HTTPS.build(host: host, path: path, query: uri_query)
        uri.to_s.gsub('&', '^&')
      end
    end
  end
end
