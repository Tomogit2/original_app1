class Joke < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category

  belongs_to :user

  validates :category_id, presence: true
  validates :input_text1, presence: true
  validates :input_text2, presence: true

  validates :category_id, numericality: { other_than: 1 , message: "can't be blank"}
end
