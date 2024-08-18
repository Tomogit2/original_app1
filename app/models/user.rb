class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jokes, dependent: :destroy
  has_many :ai_jokes, dependent: :destroy

  validates :nickname, presence: true
  validates :email, presence: true
  validates :password, presence: true, format: { without: /[^\x20-\x7E]/, message: "に全角文字を含めないでください" }
end
