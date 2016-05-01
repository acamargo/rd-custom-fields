require 'test_helper'

class ContactCustomFieldValueTest < ActiveSupport::TestCase
  test "check field value saving" do
    @user = User.create(email: 'andre@localhost', password: '123')
    @custom_field_text = @user.custom_fields.create(name: 'Texto', content_type: CustomField::TEXT)
    @custom_field_textarea = @user.custom_fields.create(name: 'Área de Texto', content_type: CustomField::TEXTAREA)
    @custom_field_combobox = @user.custom_fields.create(name: 'Caixa de Seleção', content_type: CustomField::COMBOBOX, combobox_options: "1\n2\n3")
    @contact = @user.contacts.new
    @contact.email = 'user@localhost'
    @contact.custom_field_texto = 'Isto é um texto'
    @contact.custom_field_area_de_texto = 'Isto é uma área de texto'
    @contact.custom_field_caixa_de_selecao = '2'
    assert @contact.save
    assert_not_nil text_value = ContactCustomFieldValue.where(contact_id: @contact, custom_field_id: @custom_field_text).first
    assert_equal 'Isto é um texto', text_value.string_value
    assert_not_nil textarea_value = ContactCustomFieldValue.where(contact_id: @contact, custom_field_id: @custom_field_textarea).first
    assert_equal 'Isto é uma área de texto', textarea_value.text_value
    assert_not_nil combobox_value = ContactCustomFieldValue.where(contact_id: @contact, custom_field_id: @custom_field_combobox).first
    assert_equal '2', combobox_value.string_value
  end
end
