class User < ApplicationRecord
  has_one :general_info
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

#  scope :all_except, -> (user) { where.not(id: user)}

#  def self.new_with_session(params, session)
#    super.tap do |user|
#      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
#        user.email = data["email"] if user.email.blank?
#      end
#    end

#  end

#  def self.from_omniauth(auth)
#    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
#      user.email = auth.info.email
#      user.password = Devise.friendly_token[0,20]
#      user.name = auth.info.name   # assuming the room model has a name
#      user.image = auth.info.image # assuming the room model has an image
      #room.skip_confirmation!
#    end
#  end

def missing_fields
  return [] unless general_info

  general_info.attributes.keys.select do |attribute|
    value = general_info[attribute]
    Rails.logger.info("Checking attribute: #{attribute}, value: #{value}")
    # Consider values missing only if they are nil (but not false for booleans or empty arrays)
    value.nil? || (value.blank? && ![false, [], {}].include?(value))
  end
end

end
