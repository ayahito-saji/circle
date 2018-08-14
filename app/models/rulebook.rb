class Rulebook < ApplicationRecord
  belongs_to :user
  serialize :task_code
  validates :title, presence: true
end
