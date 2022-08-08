# frozen_string_literal: true

require_relative 'params/version'
require_relative 'params/config_parser'
require 'uri'
require 'json'
require 'launchy'

module PR
  module With
    module Params
      class Error < StandardError; end

      extend self

      def open(host:, path:, query:)
        uri_query = URI.encode_www_form(query)
        url_string = URI::HTTPS.build(host: host, path: path, query: uri_query).to_s
        Launchy.open(url_string)
      end

      def parse_config(file_path, scope)
        config_options = ConfigParser.new(config_file_path: file_path, scope: scope).parse!
      rescue StandardError => e
        error_message = {
          message: "Error parsing config file. Using defaults",
          reason: e.message,
          backtrace: e.backtrace&.last(10)
        }.to_json

        STDERR.puts "\e[35mWARNING\e[0m: " + error_message + "\n"
        
        {}
      end
    end
  end
end
