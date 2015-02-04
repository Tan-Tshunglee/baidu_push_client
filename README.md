# BaiduPushClient

Baidu Push SDK

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'baidu_push_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install baidu_push_client

## Usage
Read spec for usage and fixtures for request/response examples

```ruby

options = {
  server_host:  'channel.api.duapp.com',
  common_path:  '/rest/2.0/channel',
  ak:           '9k14jrtoe3HjUnOBcapGIlN8',
  sk:           'F3iDv4MMm2ZZsXVDvlMVxdueiBikjU3p'
}

messages = {
  aps: {
    alert:"Message From Baidu Push",
    sound:"",
    badge:0
    },
}
client = BaiduPushClient::Client.new(options)

client.push_all messages: messages.to_json
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/baidu_push_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
