class ContactCustomFieldValue < ActiveRecord::Base
  belongs_to :contact
  belongs_to :custom_field

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
