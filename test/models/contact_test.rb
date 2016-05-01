require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  setup do
    @user = User.create(email: 'andre@localhost', password: '123')
  end
  test "create a contact without custom fields" do
    @contact = Contact.new(user: @user)
    @contact.email = 'foo@bar'
    assert @contact.save
  end
  test "create a contact with custom field" do
    @custom_field = @user.custom_fields.create(name: 'Telefone', content_type: CustomField::TEXT)
    @contact = Contact.new(user: @user)
    @contact.email = 'foo@bar'
    @contact.custom_field_telefone = '(53) 1234-4321'
    assert @contact.save
    assert_equal '(53) 1234-4321', Contact.find(@contact.id).custom_field_telefone
  end
end
