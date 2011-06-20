require 'grant/status'
require 'grant/error'

module Grant
  class Grantor
    include Status

    attr_writer :callback

    def initialize(action)
      self.class.send(:define_method, "#{action == :find ? 'after' : 'before'}_#{action}") do |model|
        user = Grant::User.current_user
        raise Grant::Error.new(user, action, model) unless grant_disabled? || (@callback != nil && @callback.call(user, model, action))
      end
    end
  end
end
