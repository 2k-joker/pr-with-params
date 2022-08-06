# PR::With::Params
A lightweight gem that pushes current local branch to remote with upstream to origin/<local-branch-name>. It also opens a new browser window at a URL with customized params, based on specified options, which allows to open pull request with pre-populated fields.

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pr-with-params.
