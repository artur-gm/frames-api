class CirclesController < ApplicationController
  before_action :set_circle, only: [ :update, :destroy ]

  def index
    circles = Circle.all

    circles = filter_by_frame(circles)
    circles = filter_by_radius(circles)

    render json: circles.map { |circle| circle_attributes(circle) }, status: :ok
  end

  def update
    if @circle.update(circle_params)
      render json: circle_attributes(@circle), status: :ok
    else
      render json: { errors: @circle.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @circle.destroy
    head :no_content
  end

  private

  def set_circle
    @circle = Circle.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Círculo não encontrado" }, status: :not_found
  end

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end

  def filter_by_frame(circles)
    return circles unless params[:frame_id].present?
    circles.where(frame_id: params[:frame_id])
  end

  def filter_by_radius(circles)
    return circles unless params[:center_x].present? && params[:center_y].present? && params[:radius].present?

    center_x = params[:center_x].to_f
    center_y = params[:center_y].to_f
    radius = params[:radius].to_f

    circles.select do |circle|
      distance = Math.sqrt(
        (circle.center_x - center_x) ** 2 +
        (circle.center_y - center_y) ** 2
      )

      distance + circle.radius <= radius
    end
  end

  def circle_attributes(circle)
    {
      id: circle.id,
      frame_id: circle.frame_id,
      center_x: circle.center_x.to_f,
      center_y: circle.center_y.to_f,
      diameter: circle.diameter.to_f,
      created_at: circle.created_at,
      updated_at: circle.updated_at
    }
  end
end
