FactoryBot.define do
  factory :circle do
    frame
    center_x { 150.0 }
    center_y { 150.0 }
    diameter { 30.0 }
  end
  trait :negative_coordinates do
    center_x { -150.0 }
    center_y { -150.0 }
  end
end
