class Contact < ApplicationRecord
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :content, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end
