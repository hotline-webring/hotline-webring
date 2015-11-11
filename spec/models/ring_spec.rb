require "rails_helper"

RSpec.describe Ring do
  describe "#link" do
    it "adds a new redirection while preserving the ring" do
      new_redirection = build(:redirection)

      ring = Ring.new(new_redirection)
      ring.link

      redirections = Redirection.order(created_at: :asc)
      expect(redirections[0].next).to eq redirections[1]
      expect(redirections[1].next).to eq new_redirection
      expect(new_redirection.next).to eq redirections[0]
    end
  end
end
