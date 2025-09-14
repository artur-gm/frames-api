require 'rails_helper'
require 'benchmark'

RSpec.describe 'Performance da validação de quadros', type: :performance do
  let!(:frames) { FactoryBot.create_list(:frame, 1000, :sequential, :small) }

  it 'valida rapidamente com muitos quadros' do
    new_frame = FactoryBot.build(:frame, :negative_coordinates)

    time = Benchmark.realtime do
      new_frame.valid?
    end

    expect(time).to be < 0.01 # Menos de 10ms
  end
end
