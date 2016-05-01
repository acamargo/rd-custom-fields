require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "login page" do
    get :new
    assert_response :success
  end

  test "authenticate valid user" do
    user_email = 'andre@localhost'
    user_password = '123'
    new_user = User.create(email: user_email, password: user_password)
    post :create, email: user_email, password: user_password
    assert_redirected_to contacts_path
    assert_equal new_user.id, session[:user_id]
    assert_equal "Olá <b>#{user_email}</b>", flash[:info]
  end

  test "do not authenticate an invalid user" do
    new_user = User.create(email: 'andre@localhost', password: '123')
    post :create, email: 'test@localhost', password: '123'
    assert_redirected_to action: :new
  end

  test "register an user" do
    user_email = 'test@localhost'
    user_password = '123'
    post :create, email: user_email, password: user_password, register: 'on'
    assert_redirected_to contacts_path
    test_user = User.find_by_email(user_email)
    assert_not_nil test_user
    assert [:ok, test_user], User.authenticate(user_email, user_password)
  end

  test "do not register an empty user" do
    user_email = ''
    user_password = ''
    post :create, email: user_email, password: user_password, register: 'on'
    assert_redirected_to action: :new
    assert_equal "Não foi possível criar um novo usuário", flash[:danger]
  end

  test "do not register an email twice" do
    new_user = User.create(email: 'andre@localhost', password: '123')
    user_email = 'andre@localhost'
    user_password = 'abc'
    post :create, email: user_email, password: user_password, register: 'on'
    assert_redirected_to action: :new
    assert_equal "Não foi possível criar um novo usuário", flash[:danger]
  end
end
