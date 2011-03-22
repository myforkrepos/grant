module Grant
  module Status

    def grant_disabled?
      Thread.current[:grant_disabled] == true
    end

    def grant_enabled?
      Thread.current[:grant_disabled] == false
    end

    def disable_grant
      Thread.current[:grant_disabled] = true
    end

    def enable_grant
      Thread.current[:grant_disabled] = false
    end

    def without_grant
      previously_disabled = grant_disabled?

      begin
        disable_grant
        result = yield if block_given?
      ensure
        enable_grant unless previously_disabled
      end

      result
    end

    def with_grant
      previously_disabled = grant_disabled?

      begin
        enable_grant
        result = yield if block_given?
      ensure
        disable_grant if previously_disabled
      end

      result
    end

    def do_as(user)
      previous_user = Grant::User.current_user

      begin
        Grant::User.current_user = user
        result = yield if block_given?
      ensure
        Grant::User.current_user = previous_user
      end

      result
    end

  end
end
