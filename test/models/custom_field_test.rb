require 'test_helper'

class CustomFieldTest < ActiveSupport::TestCase
  test "check slug normalization" do
    custom_field = CustomField.new
    custom_field.name = 'Tamanho do Pé'
    assert_equal 'custom_field_tamanho_do_pe', custom_field.slug
  end

  test "create an undefined type" do
    user = User.create(email: 'andreribeirocamargo@gmail.com', password: 'r41lz')
    custom_field = CustomField.new
    custom_field.user = user
    custom_field.name = 'tamanho do pé'
    custom_field.content_type = 999
    assert custom_field.invalid?
    assert custom_field.errors[:content_type].present?
  end

  test "assign value to a custom field" do
    user = User.create(email: 'andreribeirocamargo@gmail.com', password: 'r41lz')
    custom_field = CustomField.create(user: user, name: 'tamanho do pé', content_type: CustomField::TEXT)
    contact = Contact.new
    contact.user = user
    contact.email = 'teste@localhost'
    contact.custom_field_tamanho_do_pe = '40'
    assert_equal '40', contact.custom_field_tamanho_do_pe
    assert contact.save
    assert_equal '40', Contact.find(contact.id).custom_field_tamanho_do_pe
  end

  test "no field named e-mail/email" do
    user = User.create(email: 'andreribeirocamargo@gmail.com', password: 'r41lz')
    custom_field = CustomField.new(user: user, name: 'e-mail', content_type: CustomField::TEXT)
    assert custom_field.invalid?
    custom_field.name = 'EMAIL'
    assert custom_field.invalid?
  end

  test "combobox field should have options" do
    user = User.create(email: 'andreribeirocamargo@gmail.com', password: 'r41lz')
    custom_field = CustomField.new(user: user, name: 'Tenista', content_type: CustomField::COMBOBOX)
    assert custom_field.invalid?
    assert custom_field.errors[:combobox_options].any?
    custom_field.combobox_options = "\n\n\n\n\n\n\n\n\n\n"
    assert custom_field.invalid?
    assert custom_field.errors[:combobox_options].any?
    custom_field.combobox_options = "Rafael Nadal\r\nNovak Djokovic\nRoger Federer"
    assert custom_field.valid?
    assert_equal ['Rafael Nadal', 'Novak Djokovic', 'Roger Federer'], custom_field.combobox_options_array
  end
end
