class AiJoke < ApplicationRecord
  belongs_to :user
  belongs_to :joke

  validates :user_id, presence: true
  validates :joke_id, presence: true
end
