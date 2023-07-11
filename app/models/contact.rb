class Contact < ApplicationRecord
  validates :content, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end
