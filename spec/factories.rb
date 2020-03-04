FactoryBot.define do
  factory :redirection do
    sequence(:slug) { |n| "slug#{n}" }
    sequence(:url) { |n| "http://notareal#{n}.domain" }
    next_id { -1 }
    original_url { url }

    after(:create) do |redirection|
      if redirection.next_id == -1
        Ring.new(redirection).link
      end
    end
  end
end
