# frozen_string_literal: true

require 'net/http'
require 'warden'

module Warden
  module Strategies
    # LINE ID Token Strategies
    #
    # @since 0.1.0
    class Line < Warden::Strategies::Base
      # @since 0.1.0
      VERIFY_TOKEN_URI = URI('https://api.line.me/oauth2/v2.1/verify')

      # @return [TrueClass|FalseClass]
      #
      # @see Warden::Strategies::Base#valid?
      #
      # @since 0.1.0
      def valid?
        params['id_token'] != nil
      end

      # @see Warden::Strategies::Base#authenticate!
      #
      # @since 0.1.0
      def authenticate!
        success? ? success!(result) : fail!(result['error_description'])
      end

      # Token verify result
      #
      # @return [Hash] the verify result
      #
      # @since 0.1.0
      def result
        @result ||= JSON.parse(response.body)
      rescue TypeError, JSON::ParserError
        {}
      end

      # Token verify success or not
      #
      # @return [TrueClass|FalseClass]
      #
      # @since 0.1.0
      def success?
        response.code.to_i == 200
      end

      private

      # @since 0.1.0
      def response
        @response ||= Net::HTTP.post_form(
          VERIFY_TOKEN_URI,
          id_token: params['id_token'],
          client_id: @env['warden'].config[:line_client_id]
        )
      end
    end
  end
end
