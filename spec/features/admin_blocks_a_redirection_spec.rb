require "rails_helper"

RSpec.feature "Admin unlinks a redirection" do
  before do
    admin_login
  end

  context "unlinking without blocking" do
    scenario "unlinks and re-adds a redirection" do
      allow(Rails.configuration).to receive(:closed).and_return(false)

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
    scenario "unlinks and blocks a redirection with the default regex" do
      redirection = create(:redirection, url: "https://foobar.neocities.org")

      visit admin_root_path
      within "[data-id=#{redirection.id}]" do
        click_on "Block and unlink"
      end

      expect(page).not_to have_text(redirection.url)
      expect(BlockedReferrer.last.host_with_path).to eq("\\A(www\\.)?foobar.neocities.org.*")
    end
  end
end
