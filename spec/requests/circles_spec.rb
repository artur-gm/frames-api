require "swagger_helper"

RSpec.describe "circles", type: :request do
  let(:frame) { FactoryBot.create(:frame) }
  let(:circle) { FactoryBot.create(:circle, frame: frame) }

  path "/circles" do
    get("listar circulos") do
      tags "Circulos"
      produces "application/json"
      parameter name: :center_x, in: :query, type: :number, required: false
      parameter name: :center_y, in: :query, type: :number, required: false
      parameter name: :radius, in: :query, type: :number, required: false
      parameter name: :frame_id, in: :query, type: :integer, required: false

      response(200, "sucesso") do
        let(:frame) { FactoryBot.create(:frame) }
        let!(:circle1) { FactoryBot.create(:circle, frame: frame, center_x: 10, center_y: 10, diameter: 20) }
        let!(:circle2) { FactoryBot.create(:circle, frame: frame, center_x: 30, center_y: 30, diameter: 20) }

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.size).to eq(2)
          expect(response).to have_http_status(:ok)
        end
      end

      response(200, "filtrar por raio") do
        let(:center_x) { 0 }
        let(:center_y) { 0 }
        let(:radius) { 25 }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.size).to eq(1)
          expect(data.first["center_x"].to_f).to eq(10.0)
        end
      end

      response(200, "filtrar por quadro") do
        let(:frame2) { FactoryBot.create(:frame) }
        let!(:circle3) { FactoryBot.create(:circle, frame: frame2) }
        let(:frame_id) { frame2.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.size).to eq(1)
          expect(data.first["frame_id"]).to eq(frame2.id)
        end
      end
    end
  end

  path "/circles/{id}" do
    parameter name: "id", in: :path, type: :string, description: "Circle ID"

    put("atualizar circulo") do
      tags "Circulos"
      consumes "application/json"
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              diameter: { type: :number },
            },
          },
        },
        required: [:circle],
      }

      response(200, "sucesso") do
        let(:id) { FactoryBot.create(:circle).id }
        let(:circle) do
          {
            circle: {
              center_x: 50.5,
              center_y: 60.5,
              diameter: 25.0,
            },
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["center_x"].to_f).to eq(50.5)
          expect(data["center_y"].to_f).to eq(60.5)
          expect(data["diameter"].to_f).to eq(25.0)
        end
      end

      response(422, "parametros invalidos") do
        let(:id) { FactoryBot.create(:circle).id }
        let(:circle) do
          {
            circle: {
              center_x: -1000, # Fora do quadro
              center_y: 60.5,
              diameter: 25.0,
            },
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
        end
      end

      response(404, "círculo não encontrado") do
        let(:id) { "invalid" }
        let(:circle) { { center_x: 50.5 } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["error"]).to eq("Círculo não encontrado")
        end
      end
    end

    delete("deletar círculo") do
      tags "círculos"

      response(204, "sucesso") do
        let(:id) { circle.id }

        run_test! do |response|
          expect(response.body).to be_empty
          expect(Circle.find_by(id: circle.id)).to be_nil
        end
      end

      response(404, "círculo não encontrado") do
        let(:id) { "invalid" }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
