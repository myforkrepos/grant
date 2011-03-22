module Grant
  class Error < StandardError
    attr_reader :user, :action, :model

    def initialize(*args)
      if args.size == 3
        @user, @action, @model = args
      else
        @message = args[0]
      end
    end

    def to_s
      if @message
        @message
      else
        user_str = user == nil ? 'Anonymous' : "#{user.class.name}:#{user.id}"
        "#{action} permission not granted to #{user_str} for resource #{model.class.name}:#{model.id}"
      end
    end
  end
end
