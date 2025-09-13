FactoryBot.define do
  factory :circle do
    frame
    center_x { rand(50.0..150.0) }
    center_y { rand(50.0..250.0) }
    diameter { rand(10.0..40.0) }
  end
end
