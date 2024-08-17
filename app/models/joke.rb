class Joke < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  def new_joke?
    created_at >= 24.hours.ago
  end
  
  belongs_to_active_hash :category

  belongs_to :user
  has_one :ai_joke, dependent: :destroy

  validates :category_id, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2, less_than_or_equal_to: 15 }
  validates :input_text1, presence: true
  validates :input_text2, presence: true

end
