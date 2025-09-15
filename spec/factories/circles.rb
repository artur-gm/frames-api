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
  trait :sequential do
    frame { association :frame, :sequential, :small }
    sequence(:center_x) { |n| n * 10 }
    sequence(:center_y) { |n| n * 10 }
  end
  trait :small do
    diameter { 4.0 }
  end
end
