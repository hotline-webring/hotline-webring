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

  describe ".in_ring_order" do
    it "returns redirections in the order they appear next in the ring" do
      create(:redirection)
      first = Redirection.order(id: :asc).first
      next_one = first.next
      final = next_one.next

      expect(Redirection.in_ring_order).to match_array([first, next_one, final])
    end
  end

  describe ".latest_first" do
    it "returns the redirections with the most recently created first" do
      redirection = create(:redirection)
      edward = Redirection.find_by(slug: "edward")
      gabe = Redirection.find_by(slug: "gabe")

      expect(Redirection.latest_first).to eq([redirection, edward, gabe])
    end
  end

  describe ".most_recent" do
    it "returns the one, most recently created redirection" do
      redirection = create(:redirection)

      expect(Redirection.most_recent).to eq(redirection)
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

  describe "#tag_uri" do
    it "returns a properly formatted id string" do
      redirection = create(
        :redirection,
        created_at: DateTime.new(1999, 2),
        url: "http://notareal.domain"
      )
      id = "tag:hotlinewebring.club,1999-02-01T00:00:00Z:http://notareal.domain"

      expect(redirection.tag_uri).to eq(id)
    end
  end

  describe "#unlink" do
    it "destroys the redirection" do
      redirection = create(:redirection)

      redirection.unlink

      expect(Redirection.exists?(id: redirection.id)).to be_falsey
    end

    it "links the redirection's previous to its next" do
      gabe = Redirection.find_by!(slug: "gabe")
      edward = Redirection.find_by!(slug: "edward")
      redirection = create(:redirection)

      redirection.unlink

      edward.reload
      gabe.reload
      expect(edward.next).to eq gabe
      expect(gabe.next).to eq edward
    end
  end
end
