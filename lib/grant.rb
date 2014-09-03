require 'active_record'
require 'grant/grantable'
require 'grant/error'

ActiveRecord::Base.send :include, Grant::Grantable

if defined?(ActionController) and defined?(ActionController::Base)

  require 'grant/user'

  ActionController::Base.class_eval do
    before_filter do |c|
      Grant::User.current_user = c.send(:current_user) if c.respond_to?(:current_user)
    end
  end

end

