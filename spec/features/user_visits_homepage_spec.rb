require "rails_helper"

RSpec.feature "User visits homepage" do
  scenario "sees list of redirections" do
    visit root_path

    within("table.redirections") do
      expect(page).to have_content("gabebw")
      expect(page).to have_content("http://gabebw.com")
      expect(page).to have_content("edward")
      expect(page).to have_content("http://edwardloveall.com")
    end
  end
end
