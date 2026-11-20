require "rails_helper"

RSpec.describe Block do
  describe "#blocked?" do
    it "blocks regardless of HTTP vs HTTPS" do
      create(:blocked_referrer, uri_pattern: "evil.com")

      expect(Block.new("http://evil.com")).to be_blocked
      expect(Block.new("https://evil.com")).to be_blocked
    end

    it "blocks the URL exactly" do
      create(:blocked_referrer, uri_pattern: "evil.com")

      expect(Block.new("https://evil.com")).to be_blocked
    end

    it "blocks case-insensitively" do
      create(:blocked_referrer, uri_pattern: "*.evil.com/*")

      expect(Block.new("https://fOo.EVIL.com/ANYthing/goes/here")).to be_blocked
    end

    it "does not block a different domain; even a prefix" do
      create(:blocked_referrer, uri_pattern: "evil.com")

      expect(Block.new("https://notevil.com/")).not_to be_blocked
    end

    it "never blocks nil" do
      create(:blocked_referrer, uri_pattern: "evil.com")

      expect(Block.new(nil)).not_to be_blocked
    end
  end

  context "with subdomain patterns" do
    it "does not block domains that end in the blocked domain" do
      create(:blocked_referrer, uri_pattern: "*.evil.com")

      expect(Block.new("https://notevil.com")).not_to be_blocked
    end

    it "blocks any level of subdomain (at least one) with a *. pattern" do
      create(:blocked_referrer, uri_pattern: "*.evil.com")
      create(:blocked_referrer, uri_pattern: "*.more.evil.com")

      expect(Block.new("https://www.evil.com")).to be_blocked
      expect(Block.new("https://cool.evil.com")).to be_blocked
      expect(Block.new("https://yes.this.is.cool.evil.com")).to be_blocked
      expect(Block.new("https://way.more.evil.com")).to be_blocked
    end

    it "does not block the absence of a subdomain" do
      create(:blocked_referrer, uri_pattern: "*.evil.com")

      expect(Block.new("https://evil.com")).not_to be_blocked
    end

    it "does not block when the given URL contains a prefix of the blocked URL" do
      create(:blocked_referrer, uri_pattern: "*.evil.com")

      expect(Block.new("http://not-evil.com")).not_to be_blocked
    end

    it "does not block bare domains" do
      create(:blocked_referrer, uri_pattern: "*.evil.com")

      expect(Block.new("http://evil.com")).not_to be_blocked
    end
  end

  context "with /* subpath pattern" do
    it "blocks a referrer with no subpath" do
      create(:blocked_referrer, uri_pattern: "evil.com/*")

      expect(Block.new("https://evil.com")).to be_blocked
    end

    it "blocks any path" do
      create(:blocked_referrer, uri_pattern: "evil.com/*")

      expect(Block.new("https://evil.com/anything/goes/here")).to be_blocked
    end

    it "blocks deeper subpaths" do
      create(:blocked_referrer, uri_pattern: "evil.com/subpath/*")

      expect(Block.new("https://evil.com/subpath/sub-subpath")).to be_blocked
    end

    it "blocks when no deeper subpaths are present" do
      create(:blocked_referrer, uri_pattern: "evil.com/subpath/*")

      expect(Block.new("https://evil.com/subpath/")).to be_blocked
    end

    it "does not block a path that is a prefix of the blocked path" do
      create(:blocked_referrer, uri_pattern: "evil.com/subpath/*")

      expect(Block.new("https://evil.com/subpathABC")).not_to be_blocked
    end

    it "does not block a parent path" do
      create(:blocked_referrer, uri_pattern: "good.com/~evil/*")

      expect(Block.new("http://good.com")).not_to be_blocked
      expect(Block.new("http://good.com/~evil")).to be_blocked
    end

    it "blocks in a trailing-slash-agnostic way" do
      create(:blocked_referrer, uri_pattern: "good.com/~evil/*")

      expect(Block.new("http://good.com/~evil/")).to be_blocked
      expect(Block.new("http://good.com/~evil")).to be_blocked
    end
  end
end
