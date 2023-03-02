class Team < ApplicationRecord
  has_many :players

  validates :name, :acronym, presence: true
end
