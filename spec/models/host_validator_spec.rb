require "rails_helper"

RSpec.describe HostValidator do
  describe "#invalid?" do
    %w(
      http://localhost:3000
      http://devsite.example
      http://devsite.test
      http://devsite.local
      http://0.0.0.0:8000
      http://127.0.0.1:3000
      http://192.168.1.0
      http://10.101.145.9/
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
