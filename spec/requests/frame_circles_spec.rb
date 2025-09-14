require 'swagger_helper'

RSpec.describe 'FrameCircles', type: :request do
  let(:frame) { FactoryBot.create(:frame) }

  path '/frames/{frame_id}/circles' do
    parameter name: 'frame_id', in: :path, type: :string, description: 'Frame ID'

    post('criar círculo') do
      tags 'Circles'
      consumes 'application/json'
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number },
          center_y: { type: :number },
          diameter: { type: :number }
        },
        required: [ :center_x, :center_y, :diameter ]
      }

      response(201, 'círculo criado com sucesso') do
        let(:frame_id) { frame.id }
        let(:circle) do
          {
            circle: {
              center_x: 40.0,
              center_y: 40.0,
              diameter: 30.0
            }
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['circle']['center_x'].to_f).to eq(40.0)
          expect(data['circle']['center_y'].to_f).to eq(40.0)
          expect(data['circle']['diameter'].to_f).to eq(30.0)
          expect(data['circle']['frame_id']).to eq(frame.id)
          expect(response).to have_http_status(:created)
        end
      end

      response(201, 'círculo com coordenadas negativas criado com sucesso') do
        let(:frame) { FactoryBot.create(:frame, :negative_coordinates) }
        let(:frame_id) { frame.id }
        let(:circle) do
          {
            circle: {
              center_x: -50.0,
              center_y: -60.0,
              diameter: 20.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['circle']['center_x'].to_f).to eq(-50.0)
          expect(data['circle']['center_y'].to_f).to eq(-60.0)
          expect(response).to have_http_status(:created)
        end
      end

      response(422, 'parâmetros do círculo inválidos') do
        let(:frame_id) { frame.id }
        let(:circle) do
          {
            circle: {
              center_x: 1000.0, # Fora do frame
              center_y: 1000.0,
              diameter: 50.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to be_present
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      response(422, 'círculo toca outro círculo') do
        let(:frame_id) { frame.id }
        let!(:existing_circle) { FactoryBot.create(:circle, frame: frame, center_x: 30.0, center_y: 30.0, diameter: 30.0) }
        let(:circle) do
          {
            circle: {
              center_x: 60.0, # Muito próximo do círculo existente
              center_y: 30.0,
              diameter: 30.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to include('Circulos não podem se tocar ou se sobrepor')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      response(404, 'quadro não encontrado') do
        let(:frame_id) { 'invalid-id' }
        let(:circle) do
          {
            circle: {
              center_x: 40.0,
              center_y: 40.0,
              diameter: 30.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Quadro não encontrado')
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
