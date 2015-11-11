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
    it { should validate_uniqueness_of :next_id }
    it { should validate_uniqueness_of :slug }
  end

  describe "#next_url" do
    it "returns the url of the next referenced redirection" do
      gabe = create(:redirection, :gabe)
      edward = create(:redirection, :edward, next: gabe)
      gabe.update(next: edward)

      expect(gabe.next_url).to eq(edward.url)
    end
  end

  describe "#previous_url" do
    it "returns the url of the previous referenced redirection" do
      gabe = create(:redirection, :gabe)
      edward = create(:redirection, :edward, next: gabe)
      gabe.update(next: edward)

      expect(gabe.previous_url).to eq(edward.url)
    end
  end
end
