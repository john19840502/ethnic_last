FactoryGirl.define do
  factory :impressions, :class => Spree::Impression do
    title { Faker::Name.name }
    sub_title { Faker::Name.name }
    description {Faker::Lorem.paragraph}
  end
end