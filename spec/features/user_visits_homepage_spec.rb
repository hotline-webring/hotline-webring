require "rails_helper"

RSpec.feature "User visits homepage" do
  scenario "sees list of redirections" do
    visit root_path

    within("table.redirections") do
      expect(page).to have_content("gabebw")
      expect(page).to have_content("edward")

      %w(http://gabebw.com http://edwardloveall.com).each do |url|
        expect(page).to have_content(url)
        expect(page).to have_css("a[href='#{url}']")
      end
    end
  end
end
