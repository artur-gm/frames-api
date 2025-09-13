class Circle < ApplicationRecord
  belongs_to :frame

  scope :with_calculated_edges, -> {
          select("*, " \
                 "(center_y + diameter/2) as top_edge, " \
                 "(center_y - diameter/2) as bottom_edge, " \
                 "(center_x - diameter/2) as left_edge, " \
                 "(center_x + diameter/2) as right_edge")
        }

  def self.metrics_for_frame(frame_id)
    circles = where(frame_id: frame_id).with_calculated_edges.to_a

    return {} if circles.empty?

    {
      highest: circles.max_by(&:top_edge),
      lowest: circles.min_by(&:bottom_edge),
      leftmost: circles.min_by(&:left_edge),
      rightmost: circles.max_by(&:right_edge),
      count: circles.size,
    }
  end

  def radius
    diameter / 2.0
  end

  def top_edge; read_attribute(:top_edge) || center_y + diameter / 2; end
  def bottom_edge; read_attribute(:bottom_edge) || center_y - diameter / 2; end
  def left_edge; read_attribute(:left_edge) || center_x - diameter / 2; end
  def right_edge; read_attribute(:right_edge) || center_x + diameter / 2; end
end
