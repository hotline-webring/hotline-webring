FactoryBot.define do
  factory :blacklisted_referrer do
    sequence(:host_with_path) { |n| "evil.com/#{n}" }
  end

  factory :redirection do
    sequence(:slug) { |n| "slug#{n}" }
    sequence(:url) { |n| "http://example#{n}.com" }
    next_id { -1 }
    original_url { url }

    after(:create) do |redirection|
      if redirection.next_id == -1
        Ring.new(redirection).link
      end
    end
  end
end
