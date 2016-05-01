class CustomField < ActiveRecord::Base
  TEXT = 1
  TEXTAREA = 2
  COMBOBOX = 3

  belongs_to :user

  validates :name, presence: true
  validates :content_type, inclusion: { in: [TEXT, TEXTAREA, COMBOBOX] }
  validates_associated :user

  validate do
    if ['email', 'e-mail'].include? name.to_s.downcase
      errors.add(:name, 'forbidden')
    end
  end

  has_many :contact_custom_field_value

  def name=(value)
    self.slug = normalize(value)
    write_attribute :name, value
  end

  def combobox_options=(value)
    write_attribute :combobox_options, value.to_s.gsub(/[\r\n|\n]+/, "\n").chomp
  end

  def content_type_options
    {
      TEXT => 'Texto',
      TEXTAREA => 'Área de Texto',
      COMBOBOX => 'Caixa de Seleção'
    }
  end

  def content_type_name
    content_type_options[content_type]
  end

  def content_type_text?
    content_type == TEXT
  end

  def content_type_textarea?
    content_type == TEXTAREA
  end

  def content_type_combobox?
    content_type == COMBOBOX
  end

  private

  def normalize(value)
    'custom_field_' + I18n.transliterate(value).downcase.split.join('_')
  end
end
