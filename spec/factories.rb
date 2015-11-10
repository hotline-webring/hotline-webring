FactoryGirl.define do
  factory :redirection do
    trait :gabe do
      slug "gabe"
      url "http://gabebw.com"
    end

    trait :edward do
      slug "edward"
      url "http://edwardloveall.com"
    end
  end
end
