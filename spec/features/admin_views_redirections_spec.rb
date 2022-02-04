require "rails_helper"

RSpec.feature "Admin views redirections" do
  scenario "cannot get in if they do not know the username or password" do
    admin_login(admin_wrong_username, admin_wrong_password)
    visit admin_root_path

    expect(page).not_to have_text(Redirection.first.slug)
    expect(page).to have_text("Access denied")
  end

  scenario "sees list of redirections" do
    admin_login
    visit admin_root_path

    Redirection.all.each do |redirection|
      expect(page).to have_text(redirection.slug)
      expect(page).to have_text(redirection.url)
      expect(page).to have_text(redirection.original_url)
    end
  end
end
