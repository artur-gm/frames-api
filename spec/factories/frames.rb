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
  end
end
