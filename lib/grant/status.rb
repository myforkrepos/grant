module Grant
  module Status

    @@grant_disabled = false

    def grant_disabled?
      @@grant_disabled == true
    end

    def grant_enabled?
      @@grant_disabled == false
    end

    def disable_grant
      @@grant_disabled = true
    end

    def enable_grant
      @@grant_disabled = false
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

    module_function :grant_enabled?, :grant_disabled?, :disable_grant, :enable_grant, :without_grant, :with_grant, :do_as
  end
end
