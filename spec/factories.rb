FactoryGirl.define do
  factory :redirection do
    sequence(:slug) { |n| "slug#{n}" }
    sequence(:url) { |n| "http://example#{n}.com" }
    next_id -1

    after(:create) do |redirection|
      if redirection.next_id == -1
        Ring.new(redirection).link
      end
    end
  end
end
