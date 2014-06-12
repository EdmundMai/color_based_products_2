class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
         
         
  validates_format_of :email, :with  => Devise.email_regexp, if: Proc.new { |u| !u.guest? }
  validates :email, :presence => true, :uniqueness => true, if: ->(u) { !u.guest }
  # validates_uniqueness_of :email, if: ->(u) { puts "u.guest = #{u.guest}"; !u.guest }
  validates_length_of :password, :within => Devise.password_length, :allow_blank => true, if: Proc.new { |u| !u.guest? }

  validates_format_of :guest_email, :with  => Devise.email_regexp, if: Proc.new { |u| u.guest? }
  
  # validates_uniqueness_of    :email,     :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_presence_of   :password, :on=>:create
  validates_confirmation_of   :password, :on=>:create
         
  has_one :cart, dependent: :destroy
  has_many :orders
  
  after_create :create_cart!
  
  def last_incomplete_order
    self.orders.where(status: Order::INCOMPLETE).first_or_create
  end
  
  def last_complete_order
    self.orders.where(status: Order::IN_PROGRESS).last
  end
  
  def create_cart!
    self.cart = Cart.new(user_id: self.id)
    self.cart.save
  end
end
