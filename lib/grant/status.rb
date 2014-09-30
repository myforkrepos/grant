module Grant
  module Status
    #
    # Thread dependant status
    #
    module MonoThread
      module InstanceMethods 
        #
        # 1 status per thread
        #
        def is_grant_disabled
          Thread.current[:grant_disabled]
        end

        def is_grant_disabled= value
          Thread.current[:grant_disabled] = value
        end
      end

      def self.included receiver
        receiver.send :include, InstanceMethods
        receiver.module_eval do
          module_function :is_grant_disabled, :is_grant_disabled=
        end
      end
    end

    #
    # Multi thread status
    #
    module MultiThread
      module InstanceMethods 
        def is_grant_disabled
          @@grant_disabled ||= false
        end

        def is_grant_disabled= value
          @@grant_disabled = value
        end
      end

      def self.included receiver
        receiver.send :include, InstanceMethods
        receiver.module_eval do
          module_function :is_grant_disabled, :is_grant_disabled=
        end
      end
    end

    include MonoThread

    #
    # Change to global status (use ONLY in test env)
    #
    def switch_to_multithread
      Grant::Status.send :include, MultiThread
    end
    def switch_to_monothread
      Grant::Status.send :include, MonoThread
    end

    #
    # Status
    #
    def grant_disabled?
      is_grant_disabled == true
    end

    def grant_enabled?
      ! grant_disabled?
    end

    #
    # Getters/Setters
    #
    def disable_grant
      self.is_grant_disabled = true
    end

    def enable_grant
      self.is_grant_disabled = false
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

    module_function :grant_enabled?, :grant_disabled?, :disable_grant, :enable_grant,
      :without_grant, :with_grant, :do_as, :switch_to_multithread,
      :switch_to_monothread
  end
end
