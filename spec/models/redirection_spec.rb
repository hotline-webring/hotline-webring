require "rails_helper"

RSpec.describe Redirection do
  describe "associations" do
    it { should belong_to(:next).
                class_name("Redirection") }
    it { should have_one(:previous).
                class_name("Redirection").
                with_foreign_key("next_id") }
  end

  describe "validations" do
    it { should validate_presence_of :slug }
    it { should validate_presence_of :url }

    context "uniqueness" do
      before { create(:redirection) }

      it { should validate_uniqueness_of :next_id }
      it { should validate_uniqueness_of :slug }
    end
  end

  describe "#next_url" do
    it "returns the url of the next referenced redirection" do
      first = Redirection.first
      redirection = build(:redirection)
      Ring.new(redirection).link

      first.reload
      expect(first.next_url).to eq(redirection.url)
    end
  end

  describe "#previous_url" do
    it "returns the url of the previous referenced redirection" do
      first = Redirection.first
      redirection = build(:redirection)
      Ring.new(redirection).link

      expect(first.previous_url).to eq("http://edwardloveall.com")
    end
  end
end
