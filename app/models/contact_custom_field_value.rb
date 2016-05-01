class ContactCustomFieldValue < ActiveRecord::Base
  belongs_to :contact
  belongs_to :custom_field

  validate do
    errors.add(:contact, I18n.t('errors.messages.blank')) if contact.blank?
    if custom_field.blank?
      errors.add(:custom_field, I18n.t('errors.messages.blank'))
    elsif custom_field.content_type_combobox? && !custom_field.combobox_options_array.include?(value)
      errors.add(:value, I18n.t('errors.messages.inclusion')) 
    end
  end

  def value=(value)
    if custom_field.content_type_textarea?
      write_attribute :text_value, value
    else
      write_attribute :string_value, value
    end
  end

  def value
    if custom_field.content_type_textarea?
      text_value
    else
      string_value
    end
  end
end
