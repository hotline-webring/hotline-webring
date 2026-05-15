require "rails_helper"

RSpec.describe "Redirection request" do
  it "allows for both /previous and /prev" do
    expect(get("/something/previous")).to route_to(
      controller: "redirections",
      action: "previous",
      slug: "something"
    )
    expect(get("/something/prev")).to route_to(
      controller: "redirections",
      action: "previous",
      slug: "something"
    )
  end
end
