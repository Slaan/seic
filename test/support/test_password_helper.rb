require "bcrypt"

module TestPasswordHelper
  def default_password_digest
    BCrypt::Password.create(default_password, cost: 4)
  end

  def default_password
    "foobarfoobar"
  end
end
