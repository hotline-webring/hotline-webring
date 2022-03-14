require "rails_helper"

RSpec.feature "Admin edits redirection" do
  scenario "edits URL" do
    new_url = "https://example.com/new"
    url = "https://foobar.neocities.org"
    original_url = "https://original.neocities.org"
    slug = "binturong"
    redirection = create(:redirection, slug:, url:, original_url:)
    admin_login
    visit admin_root_path

    within "[data-id=#{redirection.id}]" do
      click_on "Edit"
    end

    fill_in "URL", with: new_url
    click_on "Update"

    expect(page).not_to have_content(url)
    expect(page).to have_content(new_url)
    expect(page).to have_content(original_url)
  end
end
