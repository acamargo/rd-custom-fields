require 'rfc2822'

class User < ActiveRecord::Base
  validates :password, presence: true
  validates :email, uniqueness: true
  validate do
    errors.add(:email, I18n.t('errors.messages.invalid')) unless email =~ RFC2822::EmailAddress
  end

  has_many :custom_fields
  has_many :contacts

  def password=(value)
    self.password_salt = Digest::SHA1.hexdigest(DateTime.now.to_s)
    write_attribute :password, User.scramble_password(value, password_salt)
  end

  def self.authenticate(user, pass)
    if user = find_by_email(user)
      if user.password == User.scramble_password(pass, user.password_salt)
        return [:ok, user]
      else
        return [:error, :password]
      end
    end
    [:error, :email]
  end

  def self.scramble_password(value, salt)
    Digest::SHA1.hexdigest("#{value}|#{salt}")
  end
end
