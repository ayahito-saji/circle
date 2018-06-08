class Room < ApplicationRecord
  has_many :users

  serialize :phase_env
  serialize :variable_env
  serialize :stack
  serialize :operators

  validates :name, presence: true, length: { maximum: 50 }
  validates :password, length: { maximum: 50 }
end
