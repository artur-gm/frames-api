require "swagger_helper"

RSpec.describe "quadros", type: :request do
  path "/frames" do
    post("criar quadro") do
      tags "Quadros"
      consumes "application/json"
      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          frame: {
            type: :object,
            properties: {
              center_x: { type: :number, format: :float },
              center_y: { type: :number, format: :float },
              width: { type: :number, format: :float },
              height: { type: :number, format: :float },
            },
            required: [:center_x, :center_y, :width, :height],
          },
          circles: {
            type: :array,
            items: {
              type: :object,
              properties: {
                center_x: { type: :number, format: :float },
                center_y: { type: :number, format: :float },
                diameter: { type: :number, format: :float },
              },
            },
          },
        },
        required: [:frame],
      }

      response(201, "quadro criado com sucesso") do
        let(:frame) do
          {
            frame: {
              center_x: 100.5,
              center_y: 150.3,
              width: 200.0,
              height: 300.0,
            },
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["frame"]["center_x"].to_d).to eq(100.5)
          expect(data["frame"]["center_y"].to_d).to eq(150.3)
          expect(response).to have_http_status(:created)
        end
      end

      response(201, "quadro com circulos criado com sucesso") do
        let(:frame) do
          {
            frame: {
              center_x: 100.5,
              center_y: 150.3,
              width: 200.0,
              height: 300.0,
            },
            circles: [
              {
                center_x: 110.0,
                center_y: 160.0,
                diameter: 30.0,
              },
              {
                center_x: 90.0,
                center_y: 140.0,
                diameter: 25.0,
              },
            ],
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["frame"]["width"].to_d).to eq(200.0)
          expect(response).to have_http_status(:created)
        end
      end

      response(422, "parametros invalidos") do
        let(:frame) do
          {
            frame: {
              center_x: -10,
              center_y: 150.3,
              width: -1,
              height: 300.0,
            },
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  path "/frames/{id}" do
    parameter name: "id", in: :path, type: :string, description: "Frame ID"

    get("show frame") do
      tags "Frames"
      produces "application/json"

      response(200, "successful") do
        let(:frame) { FactoryBot.create(:frame, :with_circles) }
        let(:id) { frame.id }

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["frame"]).to be_present
          expect(data["metrics"]).to be_present
          expect(data["metrics"]).to include(
            "total_circles",
            "highest_circle",
            "lowest_circle",
            "leftmost_circle",
            "rightmost_circle"
          )
        end
      end

      response(404, "frame not found") do
        let(:id) { "invalid_id" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["error"]).to eq("Frame not found")
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    delete("delete frame") do
      tags "Frames"

      response(204, "frame deleted successfully") do
        let(:frame) { FactoryBot.create(:frame) } # Frame sem círculos
        let(:id) { frame.id }

        run_test! do |response|
          expect(response.body).to be_empty
          expect(Frame.find_by(id: frame.id)).to be_nil
        end
      end

      response(422, "cannot delete frame with circles") do
        let(:frame) { FactoryBot.create(:frame, :with_circles) }
        let(:id) { frame.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["error"]).to include("Cannot delete frame with associated circles")
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      response(404, "frame not found") do
        let(:id) { "invalid_id" }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
