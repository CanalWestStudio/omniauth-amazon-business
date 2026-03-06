# OmniAuth::Amazon

[![CI](https://github.com/CanalWestStudio/omniauth-amazon-business/actions/workflows/ci.yml/badge.svg)](https://github.com/CanalWestStudio/omniauth-amazon-business/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/omniauth-amazon.svg)](https://badge.fury.io/rb/omniauth-amazon)

[Amazon Business](https://developer-docs.amazon.com/amazon-business/docs) OAuth2 strategy for OmniAuth 2.x.

## Installation

Add to your Gemfile:

```ruby
gem 'omniauth-amazon'
```

## Prerequisites

Register your application in the [Amazon Business Solution Provider Portal](https://developer-docs.amazon.com/amazon-business/docs/onboarding-overview). You will need:

- A **client ID** and **client secret** (for token exchange)
- An **application ID** (`amzn1.sp.solution.*`) (for the authorize URL)
- A whitelisted callback URL: `https://your-app.com/auth/amazon/callback`

Amazon requires HTTPS for the callback URL.

## Usage

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :amazon, ENV['AMAZON_CLIENT_ID'], ENV['AMAZON_CLIENT_SECRET'],
    application_id: ENV['AMAZON_APPLICATION_ID'],
    version: 'beta'
end
```

OmniAuth 2.x requires POST requests to initiate authentication. Use `button_to` instead of `link_to`:

```erb
<%= button_to 'Sign in with Amazon Business', '/auth/amazon' %>
```

## Auth Hash

After successful authentication, `request.env['omniauth.auth']` contains:

```ruby
{
  provider: 'amazon',
  uid: 'amzn1.account.K2LI23KL2LK2',
  info: {
    email: 'user@example.com',
    name: 'Jane Doe'
  },
  credentials: {
    token: 'ACCESS_TOKEN',
    refresh_token: 'REFRESH_TOKEN',
    expires_at: 1234567890,
    expires: true
  },
  extra: {
    raw_info: {
      user_id: 'amzn1.account.K2LI23KL2LK2',
      email: 'user@example.com',
      name: 'Jane Doe'
    }
  }
}
```

## Configuration

| Option | Description |
|--------|-------------|
| `application_id` | Your SP application ID (`amzn1.sp.solution.*`). Sent as `applicationId` in the authorize URL. |
| `version` | API version (e.g., `'beta'`). Check your app settings. |
| `client_options` | Override default OAuth2 endpoints (see below). |

### Regional Endpoints

The default endpoints target North America. Override for other regions:

```ruby
provider :amazon, KEY, SECRET,
  application_id: APP_ID,
  client_options: {
    site: 'https://www.amazon.co.uk',
    token_url: 'https://api.amazon.co.uk/auth/o2/token'
  }
```

| Region | Site | Token URL |
|--------|------|-----------|
| NA | `https://www.amazon.com` | `https://api.amazon.com/auth/o2/token` |
| EU | `https://www.amazon.co.uk` | `https://api.amazon.co.uk/auth/o2/token` |
| FE | `https://www.amazon.co.jp` | `https://api.amazon.co.jp/auth/o2/token` |

## Resources

- [Amazon Business API Docs](https://developer-docs.amazon.com/amazon-business/docs)
- [Onboarding Overview](https://developer-docs.amazon.com/amazon-business/docs/onboarding-overview)
- [Authorization Workflow](https://developer-docs.amazon.com/amazon-business/docs/website-authorization-workflow)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
