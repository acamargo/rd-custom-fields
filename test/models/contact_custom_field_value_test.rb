require 'test_helper'

class ContactCustomFieldValueTest < ActiveSupport::TestCase
  setup do
    @user = User.create(email: 'andre@localhost', password: '123')
    @contact = @user.contacts.new
    @contact.email = 'user@localhost'
  end
  test "text field saving" do
    @custom_field_text = @user.custom_fields.create(name: 'Texto', content_type: CustomField::TEXT)
    @contact.custom_field_texto = 'Isto é um texto'
    assert_nothing_raised { @contact.save! }
    assert_not_nil text_value = ContactCustomFieldValue.where(contact_id: @contact, custom_field_id: @custom_field_text).first
    assert_equal 'Isto é um texto', text_value.string_value
  end
  test "textarea field saving" do
    @custom_field_textarea = @user.custom_fields.create(name: 'Área de Texto', content_type: CustomField::TEXTAREA)
    @contact.custom_field_area_de_texto = 'Isto é uma área de texto'
    assert @contact.valid?
    assert_nothing_raised { @contact.save! }
    assert_not_nil textarea_value = ContactCustomFieldValue.where(contact_id: @contact, custom_field_id: @custom_field_textarea).first
    assert_equal 'Isto é uma área de texto', textarea_value.text_value
  end
  test "combobox field saving" do
    @custom_field_combobox = @user.custom_fields.create(name: 'Caixa de Seleção', content_type: CustomField::COMBOBOX, combobox_options: "1\r\n2\n3")

    @contact.custom_field_caixa_de_selecao = '999'
    assert @contact.invalid?
    assert_equal [I18n.t('errors.messages.inclusion')],  @contact.errors[:custom_field_caixa_de_selecao]

    @contact.custom_field_caixa_de_selecao = '2'
    assert @contact.save
    assert_not_nil combobox_value = ContactCustomFieldValue.where(contact_id: @contact, custom_field_id: @custom_field_combobox).first
    assert_equal '2', combobox_value.string_value
  end
end
