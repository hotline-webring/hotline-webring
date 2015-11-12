require "rails_helper"

RSpec.describe Ring do
  describe "#link" do
    it "adds a new redirection while preserving the ring" do
      new_redirection = build(:redirection)
      gabe = Redirection.find_by!(slug: "gabe")
      edward = Redirection.find_by!(slug: "edward")

      ring = Ring.new(new_redirection)
      ring.link

      expect(gabe.reload.next).to eq new_redirection
      expect(new_redirection.next).to eq edward
      expect(edward.reload.next).to eq gabe
    end
  end
end
