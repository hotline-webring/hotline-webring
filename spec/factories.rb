FactoryBot.define do
  factory :blocked_referrer do
    sequence(:uri_pattern) { |n| "evil#{n}.com/*" }
  end

  factory :redirection do
    sequence(:slug) { |n| "slug#{n}" }
    sequence(:url) { |n| "http://example#{n}.com" }
    next_id { -1 }
    original_url { "#{url}?original" }

    after(:create) do |redirection|
      if redirection.next_id == -1
        Ring.new(redirection).link
      end
    end
  end
end
