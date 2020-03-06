require "rails_helper"

RSpec.describe HostValidator do
  describe "#invalid?" do
    %w(
      http://localhost:3000
      http://devsite.example
      http://devsite.test
      http://devsite.local
      http://127.0.0.1:3000
    ).each do |ignored|
      it "returns true for #{ignored}" do
        host_validator = HostValidator.new(ignored)

        expect(host_validator.invalid?).to be true
      end
    end

    it "returns false when there is no referrer" do
      host_validator = HostValidator.new(nil)

      expect(host_validator.invalid?).to be false
    end

    it "returns false for non-local domains" do
      host_validator = HostValidator.new("http://gabebw.com")

      expect(host_validator.invalid?).to be false
    end
  end
end
