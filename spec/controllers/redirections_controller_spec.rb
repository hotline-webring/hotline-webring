require "rails_helper"

RSpec.describe RedirectionsController do
  describe "GET :next" do
    it "redirects to the next site" do
      gabe = create(:redirection, :gabe)
      edward = create(:redirection, :edward, next: gabe)
      gabe.update(next: edward)

      get :next, slug: gabe.slug

      expect(response).to redirect_to(edward.url)
    end
  end

  describe "GET :previous" do
    it "redirects to the previous site" do
      gabe = create(:redirection, :gabe)
      edward = create(:redirection, :edward, next: gabe)
      gabe.update(next: edward)

      get :previous, slug: edward.slug

      expect(response).to redirect_to(gabe.url)
    end
  end
end
