require 'rails_helper'
require 'benchmark'
RSpec.describe 'Performance da validação de círculos', type: :performance do
  let!(:frame) { FactoryBot.create(:frame, :huge) }
  let!(:circles) { FactoryBot.create_list(:circle, 1000, :sequential, :small, frame: frame) }

  it 'valida rapidamente com muitos círculos' do
    new_circle = FactoryBot.build(:circle, :negative_coordinates)

    time = Benchmark.realtime do
      new_circle.valid?
    end

    expect(time).to be < 0.01 # Menos de 10ms
  end
  it 'valida rapidamente com muitos círculos e círculo sobreposto' do
    new_circle = FactoryBot.build(:circle)

    time = Benchmark.realtime do
      new_circle.valid?
    end

    expect(time).to be < 0.01 # Menos de 10ms
  end
end
