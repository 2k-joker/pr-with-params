# frozen_string_literal: true

require_relative 'params/version'
require_relative 'params/config_parser'
require_relative 'params/options_validator'
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
        file_path.empty? ? {} : ConfigParser.new(config_file_path: file_path, scope: scope).parse!
      rescue StandardError => e
        message = "\e[35mWARNING\e[0m: Error parsing config file. Using defaults"
        reason = "reason: #{e.message}"
        backtrace = "backtrace: #{e.backtrace&.last(10)&.join("\n")}"
        error_message = [message, reason, backtrace, "\n\n"].join("\n")

        warn error_message

        {}
      end

      def validate_options!(options)
        validators = options.delete(:validators)
        OptionsValidator.validate!(options, validators: validators)
      end
    end
  end
end
