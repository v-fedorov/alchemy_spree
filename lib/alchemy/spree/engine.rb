require 'alchemy/spree/alchemy_language_store'

module Alchemy
  module Spree
    class Engine < ::Rails::Engine
      engine_name 'alchemy_spree'

      initializer 'spree.user_class', after: 'alchemy.include_authentication_helpers' do
        ::Spree.user_class = "Alchemy::User"
        require File.join(File.dirname(__FILE__), '../../spree/authentication_helpers')
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
        Alchemy::Auth::Engine.get_instance.load(File.join(File.dirname(__FILE__), '../..', 'config/authorization_rules.rb'))
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
