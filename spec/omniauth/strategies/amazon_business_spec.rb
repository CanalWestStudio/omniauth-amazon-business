# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OmniAuth::Strategies::AmazonBusiness do
  subject(:strategy) do
    described_class.new(app, 'client_id', 'client_secret', **options).tap do |s|
      allow(s).to receive(:request).and_return(request)
    end
  end

  let(:options) { {} }

  let(:app) { ->(_env) { [200, {}, ['OK']] } }
  let(:request) { double('Request', params: {}, cookies: {}, env: {}) } # rubocop:disable RSpec/VerifiedDoubles
  let(:access_token) { double('AccessToken', options: {}) } # rubocop:disable RSpec/VerifiedDoubles
  let(:parsed_response) { profile_response }
  let(:response) { double('Response', parsed: parsed_response) } # rubocop:disable RSpec/VerifiedDoubles

  let(:profile_response) do
    {
      'user_id' => 'amzn1.account.K2LI23KL2LK2',
      'email' => 'user@example.com',
      'name' => 'Jane Doe',
      'postal_code' => '98101'
    }
  end

  before do
    allow(strategy).to receive(:access_token).and_return(access_token)
  end

  describe '#client' do
    it 'has the correct site' do
      expect(strategy.client.site).to eq('https://www.amazon.com')
    end

    it 'has the correct authorize url' do
      expect(strategy.client.options[:authorize_url]).to eq('/b2b/abws/oauth')
    end

    it 'has the correct token url' do
      expect(strategy.client.options[:token_url]).to eq('https://api.amazon.com/auth/o2/token')
    end
  end

  describe '#uid' do
    before do
      allow(access_token).to receive(:get).with('https://api.amazon.com/user/profile').and_return(response)
    end

    it 'returns the user_id from raw_info' do
      expect(strategy.uid).to eq('amzn1.account.K2LI23KL2LK2')
    end
  end

  describe '#info' do
    before do
      allow(access_token).to receive(:get).with('https://api.amazon.com/user/profile').and_return(response)
    end

    it 'returns the email' do
      expect(strategy.info['email']).to eq('user@example.com')
    end

    it 'returns the name' do
      expect(strategy.info['name']).to eq('Jane Doe')
    end

    it 'returns the postal_code' do
      expect(strategy.info['postal_code']).to eq('98101')
    end
  end

  describe '#extra' do
    before do
      allow(access_token).to receive(:get).with('https://api.amazon.com/user/profile').and_return(response)
    end

    it 'returns raw_info' do
      expect(strategy.extra[:raw_info]).to eq(profile_response)
    end
  end

  describe '#raw_info' do
    it 'fetches the user profile from the Amazon API' do
      allow(access_token).to receive(:get).with('https://api.amazon.com/user/profile').and_return(response)

      expect(strategy.raw_info).to eq(profile_response)
      expect(access_token).to have_received(:get).with('https://api.amazon.com/user/profile')
    end

    it 'memoizes the result' do
      allow(access_token).to receive(:get).and_return(response)

      2.times { strategy.raw_info }
      expect(access_token).to have_received(:get).once
    end
  end

  describe '#callback_url' do
    it 'returns the callback path without query parameters' do
      allow(strategy).to receive_messages(full_host: 'https://example.com', script_name: '')

      expect(strategy.callback_url).to eq('https://example.com/auth/amazon_business/callback')
    end

    it 'includes script_name when present' do
      allow(strategy).to receive_messages(full_host: 'https://example.com', script_name: '/sub_uri')

      expect(strategy.callback_url).to eq('https://example.com/sub_uri/auth/amazon_business/callback')
    end
  end

  describe '#authorize_params' do
    def build_strategy(**opts)
      described_class.new(app, 'client_id', 'client_secret', **opts).tap do |s|
        session = {}
        env = { 'rack.session' => session }
        allow(s).to receive_messages(
          request: double('Request', params: {}, cookies: {}, env: env), # rubocop:disable RSpec/VerifiedDoubles
          session: session,
          env: env
        )
      end
    end

    it 'includes applicationId when application_id option is set' do
      s = build_strategy(application_id: 'amzn1.sp.solution.test123')
      expect(s.authorize_params[:applicationId]).to eq('amzn1.sp.solution.test123')
    end

    it 'includes version when version option is set' do
      s = build_strategy(version: 'beta')
      expect(s.authorize_params[:version]).to eq('beta')
    end

    it 'does not include applicationId when not set' do
      s = build_strategy
      expect(s.authorize_params).not_to have_key(:applicationId)
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(strategy.callback_path).to eq('/auth/amazon_business/callback')
    end
  end
end
