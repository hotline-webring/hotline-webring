require "rails_helper"

RSpec.feature "User visits homepage" do
  scenario "sees list of redirections" do
    visit root_path

    within("table.redirections") do
      Redirection.all.each do |redirection|
        expect(page).to have_link(redirection.slug, href: redirection.url)
      end
    end
  end
end
