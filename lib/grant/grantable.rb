require 'grant/status'
require 'grant/config'
require 'grant/grantor'

module Grant
  module Grantable

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def grant(*args, &blk)
        unless self.included_modules.include?(InstanceMethods)
          include InstanceMethods
          include Grant::Status

          [:find, :create, :update, :destroy].each do |action|
            send :class_attribute, "grantor_#{action}".to_sym
            send "grantor_#{action}=".to_sym, Grant::Grantor.new(action) { false }
            send "#{action == :find ? 'after' : 'before'}_#{action}".to_sym, "grant_#{action}".to_sym
          end
        end

        Grant::Config.new(*args).actions.each do |action|
          send "grantor_#{action}=".to_sym, Grant::Grantor.new(action, &blk)
        end
      end
    end

    module InstanceMethods
      def grant_find; grantor_find.authorize!(self); end
      def grant_create; grantor_create.authorize!(self); end
      def grant_update; grantor_update.authorize!(self); end
      def grant_destroy; grantor_destroy.authorize!(self); end
    end

  end
end
