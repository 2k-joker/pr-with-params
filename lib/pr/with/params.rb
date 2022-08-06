# frozen_string_literal: true

require_relative "params/version"
require 'uri'
require 'launchy'

module PR
  module With
    module Params
      class Error < StandardError; end

      def self.open(host:, path:, query:)
        uri_query = URI.encode_www_form(query)
        url_string = URI::HTTPS.build(host: host, path: path, query: uri_query).to_s
        Launchy.open(url_string)
      end
    end
  end
end
