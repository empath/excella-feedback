class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participations, dependent: :destroy
  has_many :presentations, through: :participations, dependent: :destroy

  has_many :responses, dependent: :nullify
  has_many :questions, through: :responses, dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true

  def presentations_as_presenter
    presentations.where('is_presenter IS true')
  end

  def presentations_as_attendee
    presentations.where('is_presenter IS NOT true')
  end
end
