require 'active_record'
require 'grant/grantable'

# TODO: Remove these two requires when backwards compatibility with grant 2.0.0
# is no longer necessary
require 'grant/integration'
require 'grant/model_security'

module Grant
  class Error < StandardError; end
end

ActiveRecord::Base.send :include, Grant::Grantable

if defined?(ActionController) and defined?(ActionController::Base)

  require 'grant/user'

  ActionController::Base.class_eval do
    before_filter do
      Grant::User.current_user = self.current_user if self.respond_to?(:current_user)
    end
  end

end

