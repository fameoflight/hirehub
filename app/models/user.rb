class User < ActiveRecord::Base
  has_many :problems
  has_many :code_problems
  has_many :collections
  has_many :invites, :order => "created_at DESC"
  has_many :submission
  has_many :interviews, :order => "created_at DESC"

  before_save :sanitize
  before_create :initial_invite_balance

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable, :encryptable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :invitable, :token_authenticatable, :confirmable,
         :lockable, :async

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :organization, :password, :password_confirmation,
            :remember_me, :confirmed_at, :role, :invite_balance, :timezone, :provider, :providerid

  auto_strip_attributes :name, :organization, :password, :email, :role, :squish => true

  after_invitation_accepted :update_beta_list_user

  def recruiter?
    return self.role == 'recruiter' || admin?
  end

  def candidate?
    return self.role == 'candidate' || admin?
  end

  def admin?
    return self.role == 'admin'
  end

  def invitations
    return Invite.where('candidate_id = ?', self.id).order("created_at DESC")
  end

  def interview_invites
    return Interview.where('candidate_id = ?', self.id).order("created_at DESC")
  end

  def new_user?
    return self.sign_in_count < 5
  end

  def no_login?
    return self.sign_in_count == 0
  end

  def demo_account?
    return self.email == Settings.demo_account_email
  end

  def self.find_or_create (email, name, role)
    user = User.find_by_email(email)

    if user.nil?
      User.invite!(:email => email, :name => name, :role => role ) do |u|
        u.skip_invitation = true
      end
    end

    User.find_by_email(email)
  end

  def email_address_with_name
    "\"#{self.name}\" <#{self.email}>"
  end

  private

  def initial_invite_balance
    self.invite_balance = Settings.invite_credit
  end

  def sanitize
    self.email = self.email.downcase
  end

  def update_beta_list_user
    @beta_list_user = BetaListUser.find_by_email( self.email )
    unless @beta_list_user.nil?
      @beta_list_user.accepted = Time.now
      @beta_list_user.save
    end
  end

end
