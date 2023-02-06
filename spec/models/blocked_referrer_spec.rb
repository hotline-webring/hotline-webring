require "rails_helper"

RSpec.describe BlockedReferrer do
  describe ".new_from_url" do
    it "uses the host in most cases" do
      blocked_referrer = BlockedReferrer.new_from_url(
        "https://foobar.neocities.org/anything/else"
      )
      expect(blocked_referrer.host_with_path).to eq("foobar.neocities.org")
    end

    it "uses the host plus site name for sites.google.com" do
      blocked_referrer = BlockedReferrer.new_from_url(
        "https://sites.google.com/site/foobar/anything/else"
      )
      expect(blocked_referrer.host_with_path).to eq("sites.google.com/site/foobar")
    end

    it "removes a leading www. from the URL" do
      blocked_referrer = BlockedReferrer.new_from_url(
        "https://www.example.com"
      )

      expect(blocked_referrer.host_with_path).to eq("example.com")
    end
  end

  describe ".block_and_unlink" do
    it "blocks the site" do
      redirection = create(:redirection, url: "https://foobar.neocities.org/anything/else")

      BlockedReferrer.block_and_unlink(redirection)

      blocked_referrer = BlockedReferrer.last
      expect(blocked_referrer.host_with_path).to eq("foobar.neocities.org")
    end

    it "unlinks the redirection" do
      redirection = create(:redirection, url: "https://foobar.neocities.org/anything/else")

      BlockedReferrer.block_and_unlink(redirection)

      expect(Redirection.find_by(slug: redirection.slug)).to be_nil
    end

    it "returns the BlockedReferrer" do
      redirection = create(:redirection, url: "https://foobar.neocities.org/anything/else")

      result = BlockedReferrer.block_and_unlink(redirection)

      expect(result).to eq(BlockedReferrer.last)
    end
  end
end
