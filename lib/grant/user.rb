module Grant
  module User

    def current_user
      Thread.current[:grant_user]
    end

    def current_user=(user)
      Thread.current[:grant_user] = user
    end

    module_function :current_user, :current_user=

  end
end
