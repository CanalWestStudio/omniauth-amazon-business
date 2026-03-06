# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Amazon < OmniAuth::Strategies::OAuth2
      option :name, 'amazon'

      option :client_options, {
        site: 'https://www.amazon.com',
        authorize_url: '/b2b/abws/oauth',
        token_url: 'https://api.amazon.com/auth/o2/token'
      }

      option :authorize_options, %i[application_id version]

      uid { raw_info['user_id'] }

      info do
        {
          'email' => raw_info['email'],
          'name' => raw_info['name'],
          'postal_code' => raw_info['postal_code']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('https://api.amazon.com/user/profile').parsed
      end

      def callback_url
        full_host + callback_path
      end

      def authorize_params
        super.tap do |params|
          params[:applicationId] = options[:application_id] if options[:application_id]
          params[:version] = options[:version] if options[:version]
        end
      end
    end
  end
end
