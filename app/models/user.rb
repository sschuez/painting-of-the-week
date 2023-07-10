class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :submissions, dependent: :nullify

  def already_submitted_this_week?
    submissions.this_week.any?
  end

  def this_weeks_submission
    submissions.this_week.first
  end
end
