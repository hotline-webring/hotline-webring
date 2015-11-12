require "rails_helper"

RSpec.describe Ring do
  describe "#link" do
    it "adds a new redirection while preserving the ring" do
      redirection = Redirection.create!(
        url: "http://example.com/1",
        slug: "one",
        next_id: 0,
      )
      other_redirection = Redirection.create!(
        url: "http://example.com/2",
        slug: "two",
        next: redirection,
      )
      redirection.update!(next_id: other_redirection.id)
      new_redirection = Redirection.new(
        url: "http://example.com/3",
        slug: "three",
      )

      ring = Ring.new(new_redirection)
      ring.link

      [redirection, other_redirection].each(&:reload)
      expect(redirection.next).to eq other_redirection
      expect(other_redirection.next).to eq new_redirection
      expect(new_redirection.next).to eq redirection
    end
  end
end
