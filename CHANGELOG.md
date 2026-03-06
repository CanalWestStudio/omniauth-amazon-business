# Changelog

## 2.0.0

### Breaking Changes

- Renamed gem from `omniauth-amazon` to `omniauth-amazon-business`
- Provider name changed from `amazon` to `amazon_business`
- Callback path changed from `/auth/amazon/callback` to `/auth/amazon_business/callback`
- Module renamed from `OmniAuth::Amazon` to `OmniAuth::AmazonBusiness`
- Require Ruby >= 3.1
- Require OmniAuth ~> 2.0 and omniauth-oauth2 ~> 1.8
- Target Amazon Business OAuth2 (`/b2b/abws/oauth`) exclusively

### Added

- `uid` method returning `user_id` from Amazon profile
- `info` method returning `email` and `name`
- `raw_info` method fetching user profile from `https://api.amazon.com/user/profile`
- `callback_url` override to strip query parameters (prevents redirect_uri mismatch)
- `authorize_params` support for `applicationId` and `version` parameters
- GitHub Actions CI (Ruby 3.1–3.4)
- RuboCop with rubocop-rspec
- MFA required for gem pushes

### Removed

- Travis CI configuration
- Development dependencies from gemspec (moved to Gemfile)
- Support for Ruby < 3.1

## 1.0.1

- Initial release with basic OAuth2 client configuration
