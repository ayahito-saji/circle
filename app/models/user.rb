class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :social_profiles, dependent: :destroy
  belongs_to :room, required: false
  has_many :rulebooks

  validates :name, presence: true, length: { maximum: 50 }

  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end
end
