require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @user = User.create(email: 'andre@localhost', password: '123')
    session[:user_id] = @user.id
    @custom_field = @user.custom_fields.create(name: 'Telefone', content_type: CustomField::TEXT)
  end
  test "render index action" do
    get :index
    assert_response :success
  end
  test "create a new contact" do
    get :new
    assert_response :success
    post :create, email: 'foo@bar', custom_field_telefone: '(53) 1234-4321'
    assert_redirected_to contacts_path
    assert_equal %{Contato <b>foo@bar</b> cadastrado, <a href="#{edit_contact_path(assigns(:contact))}">clique para modificar</a>.}, flash[:info]
  end
  test "update a contact" do
    @contact = @user.contacts.new
    @contact.email = 'foo@bar'
    @contact.custom_field_telefone = '(53) 1234-4321'
    assert @contact.save
    get :edit, id: @contact
    assert_response :success
    put :update, id: @contact, email: 'user@localhost', custom_field_telefone: '(53) 1111-2222'
    assert_redirected_to contacts_path
    assert_equal 'user@localhost', assigns(:contact).email
    assert_equal '(53) 1111-2222', assigns(:contact).custom_field_telefone
    assert_equal %{Contato <b>user@localhost</b> alterado, <a href="#{edit_contact_path(assigns(:contact))}">clique para modificar</a>.}, flash[:info]
  end
  test "delete a contact" do
    @contact = @user.contacts.new
    @contact.email = 'foo@bar'
    @contact.custom_field_telefone = '(53) 1234-4321'
    assert @contact.save
    delete :destroy, id: @contact
    assert_redirected_to contacts_path
    assert_equal %{Contato <b>foo@bar</b> excluído.}, flash[:info]
  end
end
