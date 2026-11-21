require "rails_helper"

RSpec.describe BlockedReferrer do
  describe ".new_from_url" do
    it "uses the host and blocks any sub-path" do
      blocked_referrer = BlockedReferrer.new_from_url(
        "https://foobar.neocities.org/anything/else"
      )

      expect(blocked_referrer.uri_pattern).to eq("foobar.neocities.org/*")
    end
  end

  describe ".block_and_unlink" do
    it "blocks the site" do
      redirection = create(:redirection, url: "https://foobar.neocities.org/anything/else")

      referrer = BlockedReferrer.block_and_unlink(redirection)

      expect(referrer.uri_pattern).to eq("foobar.neocities.org/*")
    end

    it "unlinks the redirection" do
      redirection = create(:redirection, url: "https://foobar.neocities.org/anything/else")

      BlockedReferrer.block_and_unlink(redirection)

      expect(Redirection.exists?(slug: redirection.slug)).to eq(false)
    end

    it "returns the BlockedReferrer" do
      redirection = create(:redirection, url: "https://foobar.neocities.org/anything/else")

      result = BlockedReferrer.block_and_unlink(redirection)

      expect(result).to eq(BlockedReferrer.last)
    end
  end
end
