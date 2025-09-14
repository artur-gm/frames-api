class CirclesController < ApplicationController
  before_action :set_circle, only: [ :update, :destroy ]

  def index
    return render json: { error: "Parâmetros center_x, center_y e radius são obrigatórios" }, status: :bad_request unless
           params[:center_x].present? && params[:center_y].present? && params[:radius].present?
    circles = Circle.within_radius(params[:center_x], params[:center_y], params[:radius])
    circles = filter_by_frame(circles)

    render json: circles.map { |circle| circle_attributes(circle) }, status: :ok
  end

  def update
    if @circle.update(circle_params)
      render json: circle_attributes(@circle), status: :ok
    else
      render json: { errors: @circle.errors.full_messages },
             status: :unprocessable_content
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
