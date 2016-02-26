require "rails_helper"

RSpec.describe "Feed requests" do
  describe "GET /feed.xml" do
    it "returns an ATOM feed response" do
      create(:redirection, slug: "foo")

      get feed_path

      expect(response.content_type).to eq(Mime::Type.lookup_by_extension(:atom))
    end

    it "has required feed attributes" do
      redirection = create(:redirection)

      get feed_path

      expect(xml["title"]).to eq("Hotline Webring")
      expect(xml["updated"]).to eq(redirection.created_at.iso8601)
      expect(xml["author"]["name"]).to eq("Gabe and Edward")
    end

    it "has required entry attributes" do
      redirection = create(:redirection)
      title = "#{redirection.slug} joined Hotline Webring"
      content = redirection.url
      updated = redirection.created_at.iso8601
      id = "tag:hotlinewebring.club,#{updated}:#{redirection.url}"

      get feed_path

      expect(first_entry["title"]).to eq(title)
      expect(first_entry["slug"]).to eq(redirection.slug)
      expect(first_entry["content"]).to eq(content)
      expect(first_entry["link"]).to eq(redirection.url)
      expect(first_entry["author"]["name"]).to eq("Gabe and Edward")
      expect(first_entry["id"]).to eq(id)
      expect(first_entry["updated"]).to eq(updated)
    end

    it "uses created_at instead of updated_at for <updated> value" do
      created_at = 1.day.from_now
      create(
        :redirection,
        created_at: created_at,
        updated_at: created_at + 1.day
      )

      get feed_path

      expect(first_entry["updated"]).to eq(created_at.iso8601)
    end
  end

  def xml
    @_xml ||= Hash.from_xml(response.body)["feed"]
  end

  def first_entry
    @_first_entry ||= xml["entry"].first
  end
end
