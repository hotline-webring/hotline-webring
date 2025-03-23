require "rails_helper"

RSpec.describe RedirectionCreation do
  context "when the 'ring is open" do
    context "when the referrer is present" do
      it "creates a redirection with the full referrer" do
        referrer_hostname = "https://cool.example.com"
        full_referrer = "#{referrer_hostname}/something/else"
        slug = "cool-slug"

        RedirectionCreation.perform(full_referrer, slug, open: true)

        redirection = Redirection.find_by!(slug: slug)
        expect(redirection.url).to eq full_referrer
      end

      it "stores the original unchanged referrer" do
        referrer_hostname = "https://cool.example.com"
        full_referrer = "#{referrer_hostname}/something/else"
        slug = "cool-slug"

        RedirectionCreation.perform(full_referrer, slug, open: true)

        redirection = Redirection.find_by!(slug: slug)
        expect(redirection.original_url).to eq full_referrer
      end

      it "links the new redirection into the ring" do
        first_redirection = Redirection.first
        old_next = first_redirection.next

        redirection = RedirectionCreation.perform(
          "http://example.com",
          "slug",
          open: true
        )

        expect(redirection.previous).to eq first_redirection
        expect(redirection.next).to eq old_next
      end
    end

    context "when the referrer is blank" do
      it "always returns nil" do
        result = RedirectionCreation.perform("", "slug", open: true)

        expect(result).to be_nil
      end
    end
  end

  context "when the 'ring is closed" do
    it "returns a ClosedRedirection instead of creating a new one" do
      referrer = "https://cool.example.com"
      slug = "cool-slug"

      redirection = RedirectionCreation.perform(referrer, slug, open: false)

      expect(redirection.next_url).to eq "/pages/closed"
      expect(redirection.previous_url).to eq "/pages/closed"
    end
  end
end
