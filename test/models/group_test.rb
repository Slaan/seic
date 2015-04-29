require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  def setup
    @group = groups(:one)
  end

  test "should be valid" do
    assert @group.valid?
  end

  test "name can't be blank" do
    @group.name = "   "
    assert_not @group.valid?
  end

  test "details can't be blank" do
    @group.details = "  "
    assert_not @group.valid?
  end

  test "group name should not be too long" do
    @group.name = "a" * 51
    assert_not @group.valid?
  end

  test "group details should not be too long" do
    @group.details = "a" * 251
    assert_not @group.valid?
  end

  test "group name should be unique" do
    duplicate_group = @group.dup
    assert_not duplicate_group.valid?
  end

  test "is_member? should return true if user is member" do
    user = users(:one)
    @group.users << user
    @group.save
    assert @group.is_member? user.id
  end

  test "is_member? should return false if user is not a member" do
    assert_not @group.is_member? 1 
  end
end

