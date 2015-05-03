require 'test_helper'

class UserMessageServiceTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @user2 = users(:two)
  end

  test "should send messages" do
    recievers = []
    recievers << @user.id
    recievers << @user2.id
    message = "Hello my darling."
    sender = @user
    UserMessageService.send_messages(message, sender, recievers)
    user1_message = @user.recieved_messages.first
    user2_message = @user2.recieved_messages.first
    assert_equal user1_message.message, message
    assert_equal user2_message.message, message
    assert_equal user1_message.sender, sender
    assert_equal user2_message.sender, sender
  end

  test "should send message to group members" do
    group = Group.create(name: "Test Group 1x48", details: "Test Details")
    group.users << @user2
    group.save!
    message = "Hello my darling."
    sender = @user
    UserMessageService.send_group_message(message, sender, group)
    recieved_message = @user2.recieved_messages.first
    assert_equal recieved_message.message, message
    assert_equal recieved_message.sender, sender
  end
end
 
