require "rails_helper"

RSpec.describe RedirectionsController do
  describe "GET :next" do
    it "redirects to the next site" do
      gabe = Redirection.find_by!(slug: "gabe")
      next_redirection = gabe.next

      get :next, slug: gabe.slug

      expect(response).to redirect_to(next_redirection.url)
    end
  end

  [:next, :previous].each do |action|
    describe "GET #{action}" do
      it "creates a Redirection if it doesn't exist" do
        new_slug = "new"
        url = "http://example.com"
        first_redirection = Redirection.first
        old_next = first_redirection.next

        request.env["HTTP_REFERER"] = url
        get action, slug: new_slug

        new_redirection = Redirection.find_by!(slug: new_slug)
        first_redirection.reload
        expect(first_redirection.next.slug).to eq new_slug
        expect(new_redirection.url).to eq url
        expect(new_redirection.next).to eq old_next
      end

      it "uses the referrer's hostname, including subdomain" do
        new_slug = "new"
        hostname = "http://cool.example.com"

        request.env["HTTP_REFERER"] = "#{hostname}/something/else"
        get action, slug: new_slug

        expect(Redirection.find_by!(slug: new_slug).url).to eq hostname
      end

      context "when there is no referrer" do
        it "does not create a Redirection" do
          new_slug = "new"

          get action, slug: new_slug

          expect(Redirection.exists?(slug: new_slug)).to be false
        end

        it "redirects to the first redirection's next/previous URL" do
          new_slug = "new"

          get action, slug: new_slug

          if action == :next
            expect(response).to redirect_to Redirection.first.next_url
          else
            expect(response).to redirect_to Redirection.first.previous_url
          end
        end
      end
    end
  end

  describe "GET :previous" do
    it "redirects to the previous site" do
      gabe = Redirection.find_by!(slug: "gabe")
      previous = Redirection.find_by!(next: gabe)

      get :previous, slug: gabe.slug

      expect(response).to redirect_to(previous.url)
    end
  end
end
