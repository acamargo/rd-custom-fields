require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "just one email is allowed" do
    user_andre = User.new(email: 'andre@localhost', password: '123')
    assert user_andre.save
    user_joao = User.new(email: 'andre@localhost', password: '123')
    assert user_joao.invalid?
    assert_equal ['has already been taken'], user_joao.errors[:email]
  end
  test "encrypt the password" do
    new_user = User.new
    new_user.email = 'andre@localhost'
    new_user.password = '123'
    assert_not_equal '123', new_user.password
    assert new_user.save, new_user.errors.full_messages
    assert_not_equal '123', new_user.password
    assert_not_equal "123|#{new_user.password_salt}", new_user.password
  end
  test "email and password should not be blank" do
    new_user = User.new
    assert new_user.invalid?
    assert new_user.errors[:email].present?
    assert new_user.errors[:password].present?
  end
  test "check authentication" do
    new_user = User.create(email: 'andre@localhost', password: '123')
    assert_equal [:error, :email], User.authenticate('foo@bar', '123')
    assert_equal [:error, :password], User.authenticate('andre@localhost', '321')
    assert_equal [:ok, new_user], User.authenticate('andre@localhost', '123')
  end
end
