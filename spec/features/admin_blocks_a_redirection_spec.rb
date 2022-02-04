require "rails_helper"

RSpec.feature "Admin blocks and unlinks a redirection" do
  before do
    admin_login
  end

  scenario "blocks and unlinks a redirection" do
    redirection = create(:redirection, url: "https://foobar.neocities.org")

    visit admin_root_path
    within "[data-id=#{redirection.id}]" do
      click_on "Block and unlink"
    end

    expect(page).not_to have_text(redirection.url)
    expect(BlockedReferrer.last.host_with_path).to eq("foobar.neocities.org")
  end

  scenario "blocks and unlinks a redirection that uses sites.google.com" do
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
