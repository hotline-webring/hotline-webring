require "rails_helper"

RSpec.feature "Admin unlinks a redirection" do
  before do
    admin_login
  end

  context "unlinking without blocking" do
    scenario "unlinks a redirection" do
      url = "https://foobar.neocities.org"
      slug = "binturong"
      redirection = create(:redirection, slug: slug, url: url)

      visit admin_root_path
      within "[data-id=#{redirection.id}]" do
        click_on "Unlink", exact: true
      end

      expect(page).not_to have_text(url)

      # Now assert that we can re-add this slug and URL
      page.driver.header('Referer', url)
      visit "/#{slug}/next"

      expect(page).to have_text(url)
      expect(page).to have_text(slug)
    end
  end

  context "unlinking with blocking" do
    scenario "unlinks and blocks a redirection" do
      redirection = create(:redirection, url: "https://foobar.neocities.org")

      visit admin_root_path
      within "[data-id=#{redirection.id}]" do
        click_on "Block and unlink"
      end

      expect(page).not_to have_text(redirection.url)
      expect(BlockedReferrer.last.host_with_path).to eq("foobar.neocities.org")
    end

    scenario "unlinks and blocks a redirection that uses sites.google.com" do
      redirection = create(
        :redirection,
        url: "https://sites.google.com/site/foobar/something/else"
      )

      visit admin_root_path

      within "[data-id=#{redirection.id}]" do
        click_on "Block and unlink"
      end

      expect(page).not_to have_text(redirection.url)
      # Note that we are not blocking all of "sites.google.com", nor are we
      # limiting it to "/site/foobar/something/else"
      expect(BlockedReferrer.last.host_with_path).to eq("sites.google.com/site/foobar")
    end
  end
end
