module Grant
  module User

    @@user = nil
    def current_user
      @@user
    end

    def current_user=(user)
      @@user = user
    end

    module_function :current_user, :current_user=

  end
end
