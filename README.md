# PR::With::Params [![Gem Version](https://badge.fury.io/rb/pr-with-params.svg)](https://badge.fury.io/rb/pr-with-params)
A lightweight ruby gem that pushes current local branch to remote with upstream at origin/[local-branch-name]. It also opens a new pull request browser window at a URL with customized query params, based on specified options, which pre-populates certain fields in the pull request. This is especially useful when supporting multiple PR templates within a code base.

Inspired by GitHub's documentation on [using query params to create pull requets](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/using-query-parameters-to-create-a-pull-request)

## Prerequisites
This gem currently uses the [launchy gem](https://github.com/copiousfreetime/launchy) to open URLs. Ensure your code base satisfies launchy's dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pr-with-params'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pr-with-params

## Usage

Assuming you've committed your changes and your local branch is ready to be pushed, run:

```
$ pr-with-params -t new_feature_template.md -l 'work in progress'
```

For a full list of options, run `$ pr-with-params -h`

#### Using Config File

Gem supports defining options in a yaml file (`.yaml`, `.yml`) like so:
```yaml
default:
  validators:
    - conventional_commits
  base_branch: main
  template: new_feature_template.md
  assignees: 2k-joker
  labels: enhancement

bug_fix:
  template: bug_fix_template.md
  labels: bug,urgent
```

* To run with config file, use `$ pr-with-params --conf='path/to/file.yml' --scope=bug_fix`. If `--scope` option is not specified, only `:default` scope will apply.
* If you specify a config file (`--conf`) and also pass options by flag (e.g `--base-branch=develop`), the flag value will override the config value.
* All your defaults go in the `:default` scope.
* Only fields defined in another scope will override the defaults. In the example above, the final list of configs will be:

```ruby
{ validators: ['conventional_commits'], base_branch: 'main', template: 'bug_fix_template.md', assignees: '2k-joker', labels: 'bug,urgent' }
```

**Supported configs**
| Config | Type | Example |
| :--- | :---: | :--- |
| validators | `Array` | \`[conventional_commits]\` |
| base_branch | `String` | develop |
| template | `String` | new_feature_template.md |
| title | `String` | 'Update login screen' |
| lables | `String` | frontend,WIP |
| assignees | `String` | 2k-joker |

#### Validators
* **Conventional Commits**: Gem supports validation of conventional commits for PR `:title`. If you want to follow [conventional commit specs](https://www.conventionalcommits.org/en/v1.0.0/#specification) in your codebase, you may want to use this validation. To turn it on, set the `--validate-conventional-commits` flag or add `conventional_commits` to the list of validators in your config file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pr-with-params.
