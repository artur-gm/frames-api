class FrameCirclesController < ApplicationController
    before_action :set_frame

  # POST /frames/:frame_id/circles
  def create
    circle = @frame.circles.new(circle_params)

    if circle.save
      render json: {
        circle: {
          id: circle.id,
          center_x: circle.center_x,
          center_y: circle.center_y,
          diameter: circle.diameter,
          frame_id: circle.frame_id
        },
        message: "Círculo criado com sucesso"
      }, status: :created
    else
      render json: { errors: circle.errors.full_messages },
             status: :unprocessable_content
    end
  end

  private

  def set_frame
    @frame = Frame.find(params[:frame_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Quadro não encontrado" }, status: :not_found
  end

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end
end
