require 'test_helper'

class CustomFieldsControllerTest < ActionController::TestCase
  setup do
    @user = User.create(email: 'andre@localhost', password: '123')
    session[:user_id] = @user.id
  end
  test "index rendering" do
    get :index
    assert_response :success
  end
  test "create a new field" do
    get :new
    assert_response :success
    post :create, name: 'banda preferida', content_type: CustomField::COMBOBOX, combobox_options: %{The Smiths\nNew Order\nDepeche Mode}
    assert_redirected_to custom_fields_path
    assert_equal %{Campo <b>banda preferida</b> criado, <a href="#{edit_custom_field_path(assigns(:custom_field))}">clique para modificar</a>.}, flash[:info]
  end
  test "update a field" do
    @custom_field = CustomField.create(user: @user, name: 'Telefone', content_type: CustomField::TEXT)
    get :edit, id: @custom_field
    assert_response :success
    put :update, id: @custom_field, name: 'Celular', content_type: CustomField::TEXT
    assert_redirected_to custom_fields_path
    assert_equal 'Celular', assigns(:custom_field).name
    assert_equal %{Campo <b>Celular</b> alterado, <a href="#{edit_custom_field_path(assigns(:custom_field))}">clique para modificar</a>.}, flash[:info]
  end
  test "delete a field" do
    @custom_field = CustomField.create(user: @user, name: 'Telefone', content_type: CustomField::TEXT)
    delete :destroy, id: @custom_field
    assert_redirected_to custom_fields_path
    assert_equal %{Campo <b>Telefone</b> excluído.}, flash[:info]
  end
end
