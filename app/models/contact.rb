require 'rfc2822'
class Contact < ActiveRecord::Base
  belongs_to :user

  has_many :contact_custom_field_values, dependent: :delete_all

  validate do
    errors.add(:user, I18n.t('errors.messages.blank')) if user.blank?
    errors.add(:email, I18n.t('errors.messages.invalid')) unless email =~ RFC2822::EmailAddress
    user.custom_fields.comboboxes.each do |custom_field|
      errors.add(custom_field.slug, I18n.t('errors.messages.inclusion')) unless custom_field.combobox_options_array.include?(send(custom_field.slug))
    end
  end

  def method_missing(method_name, *args)
    @custom_field_values ||= load_custom_field_values
    method_name_to_s = method_name.to_s
    if method_name_to_s =~ /(.*)=$/ && @custom_field_values.has_key?($1)
      @custom_field_values[$1] = args.first
    elsif @custom_field_values.has_key? method_name_to_s
      @custom_field_values[method_name_to_s]
    else
      super
    end
  end

=begin
  # it's here for historical purpose
  # I didn't like this approach
  after_initialize do |contact|
    contact.setup_custom_fields if contact.user_id.to_i > 0
  end

  def user=(value)
    super(value)
    setup_custom_fields
    value
  end

  def setup_custom_fields
    @custom_field_values = load_custom_field_values
    user.custom_fields.each do |custom_field|
      class_eval %{def #{custom_field.slug}; @custom_field_values['#{custom_field.slug}']; end}
      class_eval %{def #{custom_field.slug}=(value); @custom_field_values['#{custom_field.slug}'] = value; end}
    end
  end
=end

  after_save :save_custom_fields

  def save_custom_fields
    if @custom_field_values
      user.custom_fields.each do |custom_field|
        if @custom_field_values.has_key? custom_field.slug
          if custom_field_value = contact_custom_field_values.find_by_custom_field_id(custom_field.id)
            custom_field_value.update_attribute :value, @custom_field_values[custom_field.slug]
          else
            new_value = ContactCustomFieldValue.new
            new_value.contact = self
            new_value.custom_field = custom_field
            new_value.value = @custom_field_values[custom_field.slug]
            new_value.save!
          end
        end
      end
    end
  end

  def load_custom_field_values
    values = {}
    user.custom_fields.each do |custom_field|
      values[custom_field.slug] = contact_custom_field_values.find_by_custom_field_id(custom_field.id).try(:value)
    end
    values
  end
end
