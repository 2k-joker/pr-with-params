require 'active_support/core_ext/hash'
require 'thor'
require 'launchy'
require 'uri'

module PRWithParams
  class CLI < Thor
    desc "open", "Open a new pull request for local branch"
    long_desc <<-LONGDESC
      `pr-wip open [options]` will open a new browser window with a pull request at a URL with customized query params from <options>.
      
      The pull request will be pre-populated with certain fields based on custom query params
    LONGDESC
    option :template, type: :string, aliases: ['-t'], desc: 'Specify the filename of the target custom PR template (e.g: bug_squash_template.md). Will use default template otherwise.'
    option :config_path, type: :string, aliases: ['-path', '-p'], default: '/.pwp/config.yml', desc: 'Path to yaml file where configs are defined. Defaults to: ~/.pwp/config.yml'
    option :scope, type: :string, aliases: ['-s'], default: 'default', desc: 'Specify the scope name under which options are defined.'
    option :base_branch, type: :string, aliases: ['-b'], desc: 'Specify the base branch for your PR (e.g: develop). Will use default branch otherwise.'
    option :title, type: :string, aliases: ['-d', '-desc', '--description'], desc: 'Specify a custom PR title. Will use the first branch commit message otherwise.'
    option :labels, type: :string, aliases: ['-l'], desc: "Specify a list of labels (e.g: 'help+wanted,bug,urgent,work+in+progress')."
    option :assignees, type: :string, aliases: ['-a'], desc: "Specify a list of assignees (e.g: 'octocat,codedog')."
    option :validators, type: :array, default: [:conventional_commits], desc: 'Specify a list of validations to run against local branch before opening pull request'
    option :ignore_conventional_commits, type: :boolean, desc: 'Allow PR titles that do not conform to conventional commits spec.'
    def open
      home_dir_path = `echo $HOME`.chomp
      config_file_path = "#{home_dir_path}/#{options[:config_path].delete_prefix('/')}"
      config_options = (options[:config_path].empty? ? {} : PRWithParams::ConfigParser.new(config_file_path: config_file_path, scope: options[:scope]).parse!).with_indifferent_access
      options[:validators].delete(:conventional_commits) if options[:ignore_conventional_commits]
      all_options = config_options.merge(options)

      branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
      base_branch = all_options.delete(:base_branch) || `git remote show origin | grep "HEAD branch" | sed 's/.*: //'`.chomp

      default_title = `git show-branch --no-name $(git log #{base_branch}..#{branch_name} --pretty=format:"%h" | tail -1)`.chomp
      all_options[:title] ||= default_title

      puts all_options
      puts options
      PRWithParams::OptionsValidator.validate!(all_options.except(:validators), validators: all_options[:validators])

      remote_git_uri = `git config --get remote.origin.url`.sub('git@github.com:', '').sub('.git', '').chomp
      uri_path = "/#{remote_git_uri}/compare/#{base_branch}...#{branch_name}"

      push_local_to_remote(branch_name, base_branch, remote_git_uri)
      open_pr_in_browser(uri_path, all_options)
    rescue StandardError => e
      message = "\e[31mERROR\e[0m: An error occurred while building or opening your custom pull request URL"
      reason = "reason: #{e.message}"
      backtrace = "backtrace: #{e.backtrace&.last(10)&.join("\n")}"
      error_message = [message, reason, backtrace, "\n\n"].join("\n")
    
      warn error_message
      exit 1
    end

    private

    def push_local_to_remote(branch_name, base_branch, remote_git_uri)
      puts "current branch: \e[36m#{branch_name}\e[0m"
      puts "base branch: \e[36m#{base_branch}\e[0m"
      puts "repo path: \e[36m#{remote_git_uri}\e[0m"
    
      push_message = "\nPushing your local branch to origin/#{branch_name}..."
      puts "\e[32m#{push_message}\e[0m"
      `sleep 1`

      system("git push -u origin #{branch_name}", exception: true)
    end

    def open_pr_in_browser(uri_path, options)
      uri_host = 'www.github.com'
      uri_query = URI.encode_www_form(options)
      url_string = URI::HTTPS.build(host: uri_host, path: uri_path, query: uri_query).to_s

      Launchy.open(url_string)
    end
  end
end
