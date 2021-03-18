# frozen_string_literal: true

require 'warden/line/version'
require 'warden/strategies/line'

module Warden
  # Warden Strategies for LINE ID Token
  #
  # @since 0.1.0
  module Line
  end
end

Warden::Config.hash_accessor :line_client_id
Warden::Strategies.add(:line, Warden::Strategies::Line)
