class BetaListUser < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :email, :email_sent, :token, :accepted, :note

  validates :name, :email, :presence => true
  validates :email, :uniqueness => { :case_sensitive => false,
        :message => 'You are already on HireHub Beta List' }

  auto_strip_attributes :name, :email, :note

  before_save :sanitize

  validate :not_current_user

  private

  def sanitize
    self.email = self.email.downcase
    begin
        self.token = SecureRandom.hex(6)
    end while self.class.exists?(:token => token)
  end

  def not_current_user
    user = User.find_by_email( self.email )
    unless user.nil?
      unless user.no_login?
        self.errors.add(:email, I18n.t("beta_list.already_user"))
      end
    end
  end
end
