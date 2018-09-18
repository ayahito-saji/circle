class Room < ApplicationRecord
  has_many :users

  serialize :program_counter
  serialize :stack

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :password, length: { maximum: 50 }

  def running?
    return !interpreter_id.nil?
  end
end
