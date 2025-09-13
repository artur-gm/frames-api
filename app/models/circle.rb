class Circle < ApplicationRecord
  belongs_to :frame

  validates :center_x, :center_y, :diameter, presence: true
  validates :diameter, numericality: { greater_than: 0 }

  validate :fits_in_frame
  validate :no_touching_circles

  scope :with_calculated_edges, -> {
          select("*, " \
                 "(center_y + diameter * 0.5) as top_edge, " \
                 "(center_y - diameter * 0.5) as bottom_edge, " \
                 "(center_x - diameter * 0.5) as left_edge, " \
                 "(center_x + diameter * 0.5) as right_edge")
        }

  def self.metrics_for_frame(frame_id)
    circles = where(frame_id: frame_id).with_calculated_edges.to_a

    return {} if circles.empty?

    {
      highest: circles.max_by(&:top_edge),
      lowest: circles.min_by(&:bottom_edge),
      leftmost: circles.min_by(&:left_edge),
      rightmost: circles.max_by(&:right_edge),
      count: circles.size
    }
  end

  def radius
    diameter / 2.0
  end

  def top_edge; read_attribute(:top_edge) || center_y + diameter / 2; end
  def bottom_edge; read_attribute(:bottom_edge) || center_y - diameter / 2; end
  def left_edge; read_attribute(:left_edge) || center_x - diameter / 2; end
  def right_edge; read_attribute(:right_edge) || center_x + diameter / 2; end

  private

  def fits_in_frame
    return unless frame && diameter

    # Verificar se todas as bordas estão dentro do quadro
    if left_edge < frame.left_edge ||
       right_edge > frame.right_edge ||
       top_edge > frame.top_edge ||
       bottom_edge < frame.bottom_edge
      errors.add(:base, "Circulo deve estar completamente dentro do quadro")
    end
  end

  def no_touching_circles
    return unless frame

    # Verificar distância entre centros deve ser maior que a soma dos raios
    other_circles = frame.circles.where.not(id: id)

    other_circles.each do |other_circle|
      distance = Math.sqrt(
        (center_x - other_circle.center_x) ** 2 +
        (center_y - other_circle.center_y) ** 2
      )

      if distance <= (radius + other_circle.radius)
        errors.add(:base, "Circulos não podem se tocar ou se sobrepor")
        break
      end
    end
  end
end
