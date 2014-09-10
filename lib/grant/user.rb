module Grant
  module User

    def current_user
      puts "Current user: #{Thread.current[:grant_user].inspect}"
      Thread.current[:grant_user]
    end

    def current_user=(user)
      puts "Set Current User: #{user.inspect}"
      Thread.current[:grant_user] = user
    end

    module_function :current_user, :current_user=

  end
end
