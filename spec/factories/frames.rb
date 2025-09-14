FactoryBot.define do
  factory :frame do
    center_x { 100.0 }
    center_y { 100.0 }
    width { 200.0 }
    height { 300.0 }

    trait :with_circles do
      after(:create) do |frame|
        create(:circle, frame: frame)
      end
    end

    trait :negative_coordinates do
      center_x { -100.0 }
      center_y { -100.0 }
    end

    trait :sequential do
      sequence(:center_x) { |n| n * 10 }
      sequence(:center_y) { |n| n * 10 }
    end

    trait :small do
      width { 5.0 }
      height { 5.0 }
    end
  end
end
