require 'grant/status'

module Grant
  class Grantor
    include Status

    attr_writer :callback

    def initialize(action)
      self.class.send(:define_method, "#{action == :find ? 'after' : 'before'}_#{action}") do |model|
        user = Grant::User.current_user
        error(user, action, self) unless grant_disabled? || (@callback != nil && @callback.call(user, model))
      end
    end

    def error(user, action, model)
      msg = ["#{action} permission",
        "not granted to #{user.class.name}:#{user.id}",
        "for resource #{model.class.name}:#{model.id}"]
      raise Grant::Error.new(msg.join(' '))
    end
  end
end
