# frozen_string_literal: true

# This is a model
class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :food_store
  has_one_attached :image

  validates :image, presence: true
  validate :image_content_type

  def image_content_type
    return unless image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/gif image/tiff])

    errors.add(:image, 'must be a JPEG, PNG, or GIF image')
  end
end
