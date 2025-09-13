class FramesController < ApplicationController
  before_action :set_frame, only: [:show, :destroy]

  # GET frames/:id
  def show
    render json: {
      frame: frame_details,
      metrics: circle_metrics,
    }, status: :ok
  end

  def create
    @frame = Frame.new(frame_params)

    if @frame.save
      # Cria círculos associados se forem fornecidos
      create_circles_if_provided

      render json: {
        frame: frame_details,
        message: "Frame created successfully",
      }, status: :created
    else
      render json: { errors: @frame.errors.full_messages },
             status: :unprocessable_content
    end
  end

  def destroy
    if @frame.circles.any?
      render json: {
        error: "Não pode deletar quadro com círculos associados",
      }, status: :unprocessable_content
    else
      @frame.destroy
      head :no_content
    end
  end
end

private

def frame_params
  params.require(:frame).permit(:center_x, :center_y, :width, :height)
end

def create_circles_if_provided
  return unless params[:circles]

  circle_params.each do |circle_param|
    @frame.circles.create(circle_param)
  end
end

def set_frame
  @frame = Frame.find(params[:id])
rescue ActiveRecord::RecordNotFound
  render json: { error: "Quadro não encontrado" }, status: :not_found
end

def frame_details
  {
    id: @frame.id,
    center_x: @frame.center_x,
    center_y: @frame.center_y,
    width: @frame.width,
    height: @frame.height,
    created_at: @frame.created_at,
    updated_at: @frame.updated_at,
  }
end

def circle_metrics
  metrics = Circle.metrics_for_frame(@frame.id)
  {
    total_circles: metrics[:count],
    highest_circle: circle_details(metrics[:highest], :top_edge),
    lowest_circle: circle_details(metrics[:lowest], :bottom_edge),
    leftmost_circle: circle_details(metrics[:leftmost], :left_edge),
    rightmost_circle: circle_details(metrics[:rightmost], :right_edge),
  }
end

def circle_details(circle, edge_type)
  return nil unless circle

  {
    id: circle.id,
    center_x: circle.center_x,
    center_y: circle.center_y,
    diameter: circle.diameter,
    edge_type => circle.send(edge_type),
  }
end

def circle_params
  # Permite array de círculos
  params.fetch(:circles, []).map do |circle|
    circle.permit(:center_x, :center_y, :diameter)
  end
end
