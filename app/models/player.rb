class Player < ApplicationRecord
  belongs_to :team

  validates :name, :position, presence: true
end
