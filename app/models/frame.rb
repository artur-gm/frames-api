class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy

  validates :center_x, :center_y, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than: 0 }

  validate :no_overlapping_frames

  def left_edge
    center_x - width / 2
  end

  def right_edge
    center_x + width / 2
  end

  def top_edge
    center_y + height / 2
  end

  def bottom_edge
    center_y - height / 2
  end

  private

  def no_overlapping_frames
    overlapping_frames = Frame.where.not(id: id).where(
      "(center_x - width/2) < ? AND (center_x + width/2) > ? AND " \
      "(center_y - height/2) < ? AND (center_y + height/2) > ?",
      center_x + width / 2, center_x - width / 2,
      center_y + height / 2, center_y - height / 2
    )

    if overlapping_frames.exists?
      errors.add(:base, "Quadros não podem estar sobrepostos")
    end
  end
end
