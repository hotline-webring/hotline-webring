require "rails_helper"

RSpec.describe RedirectionCreation do
  context "when the referrer is present" do
    it "creates a redirection with the referrer hostname" do
      referrer_hostname = "https://cool.example.com"
      slug = "cool-slug"

      RedirectionCreation.perform(
        "#{referrer_hostname}/something",
        slug,
      )

      redirection = Redirection.find_by!(slug: slug)
      expect(redirection.url).to eq referrer_hostname
    end

    it "links the new redirection into the ring" do
      first_redirection = Redirection.first
      old_next = first_redirection.next

      redirection = RedirectionCreation.perform(
        "http://example.com",
        "slug",
      )

      expect(redirection.previous).to eq first_redirection
      expect(redirection.next).to eq old_next
    end

    context "when the referrer is like http://tilde.club/~ford/something.html"do
      it "creates a redirection that includes the ~ford" do
        referrer = "http://tilde.club/~ford/something.html"
        slug = "cool-slug"

        RedirectionCreation.perform(referrer, slug)

        redirection = Redirection.find_by!(slug: slug)
        expect(redirection.url).to eq "http://tilde.club/~ford"
      end
    end
  end

  context "when the referrer is blank" do
    it "always returns nil" do
      result = RedirectionCreation.perform("", "slug")

      expect(result).to be_nil
    end
  end
end
