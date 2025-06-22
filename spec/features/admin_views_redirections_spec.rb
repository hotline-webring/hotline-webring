require "rails_helper"

RSpec.describe "Admin views redirections" do
  it "cannot get in if they do not know the username or password" do
    admin_login(admin_wrong_username, admin_wrong_password)
    visit admin_root_path

    expect(page).not_to have_text(Redirection.first.slug)
    expect(page).to have_text("Access denied")
  end

  it "sees list of redirections" do
    admin_login
    visit admin_root_path

    Redirection.all.each do |redirection|
      expect(page).to have_text(redirection.slug)
      expect(page).to have_text(redirection.url)
      expect(page).to have_text(redirection.original_url)
    end
  end

  it "sorts them by name or last seen" do
    cool = create(:redirection, slug: "cool", last_seen_at: 1.year.ago)
    neat = create(:redirection, slug: "neat", last_seen_at: 1.month.ago)
    cool.update(next: neat)
    neat.update(next: cool)

    admin_login
    visit admin_root_path

    cool_node = find(".redirection", text: "cool")
    # default order is next_id in descending order
    expect(redirection_node("neat")).to appear_before(redirection_node("cool"))

    visit "/cool/next"
    visit admin_root_path
    click_on("Most recently seen")

    expect(redirection_node("cool")).to appear_before(redirection_node("neat"))

    click_on("Least recently seen")

    expect(redirection_node("neat")).to appear_before(redirection_node("cool"))
  end

  def redirection_node(slug)
    find(".redirection", text: slug)
  end
end
