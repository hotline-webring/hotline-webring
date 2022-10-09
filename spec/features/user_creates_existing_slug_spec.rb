require "rails_helper"

RSpec.feature "User creates existing slug" do
  scenario "sees a helpful page" do
    cool = create(:redirection, slug: "cool", url: "https://cool.com")
    page.driver.header "Referer", "http://NOT-COOL.com"

    visit "/#{cool.slug}/next"

    expect(page).to have_content "picked an existing slug"
  end
end
