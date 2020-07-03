require 'rails_helper'

RSpec.describe Block do
  describe '#blocked?' do
    context 'blocking evil.com' do
      before do
        create(:blocked_referrer, host_with_path: "evil.com")
      end

      it "matches regardless of HTTP vs HTTPS" do
        url = "http://www.evil.com"
        expect(Block.new(url)).to be_blocked
      end

      it "matches regardless of www. prefix" do
        url = "https://evil.com"
        expect(Block.new(url)).to be_blocked
      end

      it "matches the URL exactly" do
        url = "https://www.evil.com"
        expect(Block.new(url)).to be_blocked
      end

      it "matches any path under the URL" do
        url = "https://www.evil.com/anything/goes/here"
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

      it "never matches nil" do
        expect(Block.new(nil)).not_to be_blocked
      end
    end
  end
end
