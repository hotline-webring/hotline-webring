require "rails_helper"

RSpec.describe Block do
  describe "#blocked?" do
    context "blocking evil.com" do
      before do
        create(:blocked_referrer, host_with_path: "evil.com")
      end

      it "matches regardless of HTTP vs HTTPS" do
        url = "http://www.evil.com"
        expect(Block.new(url)).to be_blocked
      end

      it "matches when we add a www. prefix" do
        url = "https://www.evil.com"
        expect(Block.new(url)).to be_blocked
      end

      it "matches the URL exactly" do
        url = "https://evil.com"
        expect(Block.new(url)).to be_blocked
      end

      it "matches any path under the URL" do
        url = "https://evil.com/anything/goes/here"
        expect(Block.new(url)).to be_blocked
      end

      it "is case-insensitive" do
        url = "https://EVIL.com/ANYthing/goes/here"
        expect(Block.new(url)).to be_blocked
      end

      it "does not match a subdomain that isn't 'www'" do
        url = "https://good.evil.com"
        expect(Block.new(url)).not_to be_blocked
      end

      it "does not match a subdomain that isn't 'www' with a path" do
        url = "https://good.evil.com/anything/goes/here"
        expect(Block.new(url)).not_to be_blocked
      end

      it "does not match a different domain" do
        url = "https://good.com/"
        expect(Block.new(url)).not_to be_blocked
      end

      it "does not match when the given URL contains a prefix of the blocked URL" do
        url = "http://not-evil.com"
        expect(Block.new(url)).not_to be_blocked
      end

      it "never matches nil" do
        expect(Block.new(nil)).not_to be_blocked
      end
    end

    context "blocking www.evil.com" do
      before do
        create(:blocked_referrer, host_with_path: "www.evil.com")
      end

      it "does not match evil.com (without the www.)" do
        url = "https://evil.com"
        expect(Block.new(url)).not_to be_blocked
      end

      it "matches the URL exactly" do
        url = "https://www.evil.com"
        expect(Block.new(url)).to be_blocked
      end

      it "does not match a subdomain that isn't 'www'" do
        url = "https://good.evil.com"
        expect(Block.new(url)).not_to be_blocked
      end
    end

    context "blocking evil.com/subpath" do
      before do
        create(:blocked_referrer, host_with_path: "evil.com/subpath")
      end

      it "matches the URL exactly" do
        url = "https://www.evil.com/subpath"
        expect(Block.new(url)).to be_blocked
      end

      it "matches any path under the URL" do
        url = "https://www.evil.com/subpath/sub-subpath"
        expect(Block.new(url)).to be_blocked
      end

      it "does not match a path that is a prefix of the blocked path" do
        url = "https://www.evil.com/subpathABC"
        expect(Block.new(url)).not_to be_blocked
      end

      it "does not match a parent path" do
        url = "http://www.evil.com"
        expect(Block.new(url)).not_to be_blocked
      end

      it "does not match when the given URL contains a prefix of the blocked URL" do
        url = "http://www.not-evil.com/subpath"
        expect(Block.new(url)).not_to be_blocked
      end

      it "never matches nil" do
        expect(Block.new(nil)).not_to be_blocked
      end
    end

    context "blocking an entire domain and its subdomains" do
      it "can block all of it" do
        create(:blocked_referrer, host_with_path: "ilands.ai", block_by_domain: true)

        expect(Block.new("ilands.ai")).to be_blocked
        expect(Block.new("public.ilands.ai")).to be_blocked
        expect(Block.new("public.ilands.ai/agent-bundles/1234")).to be_blocked
      end

      it "does not filter by any subpaths" do
        create(:blocked_referrer, host_with_path: "ilands.ai/foo", block_by_domain: true)

        expect(Block.new("ilands.ai")).to be_blocked
        expect(Block.new("ilands.ai/foo")).to be_blocked
        expect(Block.new("ilands.ai/bar")).to be_blocked
      end

      it "does not block other domains" do
        create(:blocked_referrer, host_with_path: "ilands.ai", block_by_domain: true)

        expect(Block.new(".ai")).not_to be_blocked
        expect(Block.new("foo.ai")).not_to be_blocked
      end

      it "does not block the main domain if the subdomain is blocked" do
        create(:blocked_referrer, host_with_path: "evil.good.com", block_by_domain: true)

        expect(Block.new("evil.good.com")).to be_blocked
        expect(Block.new("good.com")).not_to be_blocked
        expect(Block.new("something.com")).not_to be_blocked
      end
    end
  end
end
