class Article < ApplicationRecord
  belongs_to :user

  validates :title,
            presence: true,
            length: { maximum: 100 }

  validates :category,
            presence: true,
            length: { maximum: 50 }

  validates :body, presence: true
end
