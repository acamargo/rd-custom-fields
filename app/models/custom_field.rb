class CustomField < ActiveRecord::Base
  TEXT = 1
  TEXTAREA = 2
  COMBOBOX = 3

  belongs_to :user

  validates :name, presence: true
  validates :content_type, inclusion: { in: [TEXT, TEXTAREA, COMBOBOX] }

  validate do
    errors.add(:user, I18n.t('errors.messages.blank')) if user.blank?
    errors.add(:name, I18n.t('errors.messages.reserved')) if ['email', 'e-mail'].include? name.to_s.downcase
    errors.add(:combobox_options, I18n.t('errors.messages.blank')) if content_type_combobox? && combobox_options_array.empty?
  end

  has_many :contact_custom_field_value, dependent: :delete_all

  scope :comboboxes, -> { where(content_type: COMBOBOX) }

  def name=(value)
    self.slug = normalize(value)
    write_attribute :name, value
  end

  def combobox_options=(value)
    write_attribute :combobox_options, value.to_s.gsub(/[\r?\n]+/, "\n").chomp
  end

  def combobox_options_array
    combobox_options.to_s.split(/\r?\n/)
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
    'custom_field_' + sanitize(value)
  end

  def sanitize(string, options={})
    buffer = string.gsub(/\s+/, '_')
    { "ä"=>"a", "ã"=>"a", "á"=>"a", "à"=>"a", "â"=>"a", "Ä"=>"a", "Ã"=>"a", "Á"=>"a", "À"=>"a", "Â"=>"a",
      "é"=>"e", "ê"=>"e", "ë"=>"e", "É"=>"e", "Ê"=>"e", "Ë"=>"e",
      "í"=>"i", "Í"=>"i",
      "ó"=>"o", "õ"=>"o", "ô"=>"o", "ö"=>"o", "Ó"=>"o", "Õ"=>"o", "Ô"=>"o", "Ö"=>"o",
      "ú"=>"u", "Ú"=>"u", "ü"=>"u", "Ü"=>"u",
      "²"=>"2", "³"=>"3",
      "ª"=>"a", "º"=>"o", "°"=>"o", '&'=>"e",
      'ç' => 'c', 'Ç' => 'c',
      'ñ' => 'n', 'Ñ' => 'n',
      ' ' => '_', # space character
      '.' => '', '(' => '', ')' => '', '[' => '', ']' => '', '{' => '', '}' => '',
      '<' => '', '>' => '', '|' => '',
      ' ' => '', # non-breaking space
      '"' => '', "'" => '', "´" => '', '+' => '', '%' => '', '#' => '', '/' => '', ',' => '',
      '!' => '', '?' => '', ':' => '', '–' => '', '$' => 'S', '“' => '', '”' => '', '’' => '', '‘' => ''
    }.update(options).each_pair {|k,v| buffer.gsub!(k, v) }
    buffer.downcase.gsub(/[^a-z0-9\-_#{options.values.join}]/, '') # vai remover inclusive os non-printing characters
  end
end
