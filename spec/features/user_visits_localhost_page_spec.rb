require "rails_helper"

RSpec.feature "User visits localhost page" do
  scenario "sees localhost text" do
    visit page_path("localhost")

    expect(page).to have_text "testing out your links on your local site"
  end
end
