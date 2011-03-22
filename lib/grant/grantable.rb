require 'grant/status'
require 'grant/config'
require 'grant/grantor'

module Grant
  module Grantable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def grant(*args, &blk)
        include Grant::Status unless self.included_modules.include?(Grant::Status)
        initialize_grant unless grant_initialized?

        config = Grant::Config.new(*args)
        config.actions.each do |action|
          @grant_callbacks[action.to_sym].callback = blk
        end
      end

      def initialize_grant
        @grant_callbacks ||= {}
        Grant::Config.valid_actions.each do |action|
          grantor = Grant::Grantor.new(action)
          @grant_callbacks[action] = grantor
          send "#{action == :find ? 'after' : 'before'}_#{action}", grantor
        end
        @grant_initialized = true
      end

      def grant_initialized?
        @grant_initialized == true
      end
    end

    # ActiveRecord won't call the after_find handler unless it see's a specific after_find method defined
    def after_find; end unless method_defined?(:after_find)
  end
end
