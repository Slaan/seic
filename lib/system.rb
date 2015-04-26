module System

  class System

    def self.system_user
      @system_user ||= User.where("username = ?", "System").limit(1)[0]
    end

  end


end
