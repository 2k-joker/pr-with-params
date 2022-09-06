module PR
  module With
    module Params
      class OptionsValidator
        VALIDATOR_CLASS_MAP = {
          conventional_commits: 'PR::With::Params::ConventionalCommitValidator'
        }.freeze

        class << self
          def validate!(options, validators: [])
            validators.each do |validator|
              validate_options(validator, options)
            end
          end

          private

          def validate_options(validator, options)
            class_name = VALIDATOR_CLASS_MAP[validator.to_sym]
            raise(ArgumentError, "Invalid or undefined validator: #{validator}") if class_name.nil?

            Object.const_get(class_name).new(options).validate!
          end
        end
      end

      class ConventionalCommitValidator
        CONVENTIONAL_COMMIT_REGEX = /^((build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\(\w+\))?(!)?(: (.*\s*)*))|(^Merge (.*\s*)*)|(^Initial commit$)/.freeze

        def initialize(options)
          @commit_message = options[:title]
        end

        def validate!
          raise("Conventional commit specifications not met for commit message: '#{@commit_message}'") unless valid_commit?
        end

        private

        def valid_commit?
          CONVENTIONAL_COMMIT_REGEX.match?(@commit_message)
        end
      end
    end
  end
end
