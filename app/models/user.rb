class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable,omniauth_providers: [:google_oauth2]

  def to_s
    email
  end
      

  # Stripe customer's creation
  after_create do
    customer = Stripe::Customer.create(email: self.email)
    update(stripe_customer_id: customer.id)
  end


  # Google Omniauth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.fullname  = auth.info.name
      user.avatar_url = auth.info.image
    end
  end
end
