require "rails_helper"

RSpec.describe "Feed requests" do
  describe "GET /feed.xml" do
    it "returns an ATOM feed response" do
      create(:redirection, slug: "foo")

      get feed_path

      expect(response.media_type).to eq(Mime::Type.lookup_by_extension(:atom))
    end

    it "has required feed attributes" do
      redirection = create(:redirection)

      get feed_path

      expect(xml.css("feed > title").text).to eq("Hotline Webring")
      expect(xml.css("feed > updated").text).to eq(redirection.created_at.iso8601)
      expect(xml.css("feed > author > name").text).to eq("Gabe and Edward")
    end

    it "has required entry attributes" do
      redirection = create(:redirection)
      title = "#{redirection.slug} joined Hotline Webring"
      content = redirection.url
      updated = redirection.created_at.iso8601
      id = "tag:hotlinewebring.club,#{updated}:#{redirection.url}"

      get feed_path

      expect(text_of("title")).to eq(title)
      expect(text_of("content")).to eq(content)
      expect(text_of("link:not([rel])")).to eq(redirection.original_url)
      expect(text_of("link[rel=alternate]")).to eq(redirection.url)
      expect(text_of("author > name")).to eq("Gabe and Edward")
      expect(text_of("id")).to eq(id)
      expect(text_of("updated")).to eq(updated)
    end

    it "uses created_at instead of updated_at for <updated> value" do
      created_at = 1.day.from_now
      create(
        :redirection,
        created_at: created_at,
        updated_at: created_at + 1.day
      )

      get feed_path

      expect(text_of("updated")).to eq(created_at.iso8601)
    end
  end

  def xml
    @_xml ||= Nokogiri::XML(response.body)
  end

  def first_entry
    @_first_entry ||= xml.css("feed > entry").first
  end

  def text_of(selector)
    first_entry.css(selector).text
  end
end
