# Git Wand

A Ruby client to the GitHub API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git_wand'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_wand

## Usage

Instantiate a client:

```ruby
require "git_wand"

client = GitWand::GitHub::API::Client.new(
  username: "GITHUB_USERNAME_HERE",
  token: "GITHUB_TOKEN_HERE"
)
```

Interact with resources:

```ruby
result = client.current_user_info
if result.success?
  puts "[success] Current user info: #{result.body["login"]} #{result.body["html_url"]}"
else
  puts "[error] #{result.body["message"]}"
end
```

```ruby
repository_name = "this-is-a-test"
result = client.create_repository(name: repository_name)
if result.success?
  puts "[success] Repository #{repository_name} created: #{result.body["html_url"]}"
else
  puts "[error] #{result.body["message"]}"
end
```

```ruby
result = client.delete_repository(name: repository_name)
if result.success?
  puts "[success] Repository #{repository_name} deleted"
else
  puts "[error] #{result.body["message"]}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/olistik/git_wand. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

Made with <3 by [olistik](https://olisti.co).

GNU Affero General Public License (AGPL) version 3

- [gnu.org](https://www.gnu.org/licenses/agpl-3.0.txt)
- [repository copy](agpl-3.0.txt)
