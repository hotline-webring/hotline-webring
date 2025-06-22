require "rails_helper"

RSpec.describe "user visits redirection" do
  it "updates the 'Last seen' column" do
    redirection = travel_to 1.year.ago do
      create(:redirection, slug: "hello")
    end

    admin_login
    visit admin_root_path

    node = find(".redirection[data-id='#{redirection.id}']")
    within(node) do
      expect(page).to have_selector(".slug", text: "hello")
      expect(page).to have_selector(".last-seen", text: "about 1 year")
    end

    visit "/hello/next"
    visit admin_root_path

    node = find(".redirection[data-id='#{redirection.id}']")
    within(node) do
      expect(page).to have_selector(".slug", text: "hello")
      expect(page).to have_selector(".last-seen", text: "less than a minute")
    end
  end
end
