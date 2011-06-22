require 'grant/status'
require 'grant/error'

module Grant
  class Grantor
    include Status

    def initialize(action, &callback)
      @action = action
      @callback = callback
    end

    def authorize!(model, user=Grant::User.current_user)
      unless grant_disabled?
        without_grant do
          raise Grant::Error.new(user, @action, model) unless @callback.call(user, model, @action)
        end
      end
    end

    def authorized?(model, user=Grant::User.current_user)
      without_grant do
        @callback.call(user, model, @action)
      end
    end
  end
end
