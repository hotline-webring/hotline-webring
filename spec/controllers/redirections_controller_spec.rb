require "rails_helper"

RSpec.describe RedirectionsController do
  describe "GET :next" do
    it "redirects to the next site" do
      gabe = Redirection.find_by!(slug: "gabe")
      next_redirection = gabe.next

      get :next, params: { slug: gabe.slug }

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
        get action, params: { slug: new_slug }

        new_redirection = Redirection.last
        expect(new_redirection.slug).to eq new_slug
        expect(first_redirection.reload.next).to eq new_redirection
      end

      it "does not allow creating the exact same URL twice" do
        url = "https://unique-website.com"
        new_slug = "new"
        old_slug = "old"
        RedirectionCreation.perform(url, old_slug)

        request.env["HTTP_REFERER"] = url
        expect {
          get action, params: { slug: new_slug }
        }.to raise_error(ActiveRecord::RecordInvalid)

        expect(Redirection.where(slug: new_slug)).to be_empty
      end

      it "considers similar URLs to be the same" do
        old_url = "https://www.cool.com"
        old_slug = "old"
        new_url = "https://cool.com"
        new_slug = "new"
        RedirectionCreation.perform(old_url, old_slug)

        request.env["HTTP_REFERER"] = new_url
        expect {
          get action, params: { slug: new_slug }
        }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Redirection.where(slug: new_slug)).to be_empty
      end

      it "ignores requests from http://localhost" do
        request.env["HTTP_REFERER"] = "http://localhost"

        get action, params: { slug: "whatever" }

        expect(response).to redirect_to page_path(:localhost)
      end

      context "when there is no referrer" do
        it "redirects to the first redirection's #{action} URL" do
          new_slug = "new"

          get action, params: { slug: new_slug }

          url = next_or_previous(action, Redirection.first)
          expect(response).to redirect_to url
        end
      end

      context "when the URL is blocked" do
        it "does not create a redirection and redirects to the first redirection" do
          create(:blocked_referrer, host_with_path: "evil.com")
          slug = "i-am-evil"
          url = "http://evil.com/something"
          request.env["HTTP_REFERER"] = url

          get action, params: { slug: slug }

          expect(Redirection.where(slug: slug)).to be_empty
          expect(response).to redirect_to Redirection.first.url
        end

        # `hotlinewebring.club` itself is blocked (so you can't add it to the
        # webring again) but it is already in the webring, so it should work
        it "goes to the #{action} URL if it already exists" do
          redirection = create(:redirection)

          # If these URLs match `Redirection.first.url`, then we can't test that
          # it's doing something other than going to `Redirection.first`, since
          # they're indistinguishable. So add another site to the 'ring and
          # assert on our precondition.
          create(:redirection)
          expect(redirection.next_url).not_to eq Redirection.first.url
          expect(redirection.previous_url).not_to eq Redirection.first.url

          create(:blocked_referrer, host_with_path: URI.parse(redirection.url).host)
          request.env["HTTP_REFERER"] = redirection.url

          get action, params: { slug: redirection.slug }

          expect(response).to redirect_to next_or_previous(action, redirection)
        end
      end

      context "when the request comes from a bot" do
        bot_user_agent = "Mozilla/5.0 (compatible; DataForSeoBot/1.0; +https://dataforseo.com/dataforseo-bot)"

        it "redirects to the first redirection's #{action} URL" do
          new_slug = "new"

          request.env["HTTP_USER_AGENT"] = bot_user_agent
          request.env["HTTP_REFERER"] = "http://example.com"
          get action, params: { slug: new_slug }

          expect(response).to redirect_to Redirection.first.url
          expect(Redirection.where(slug: new_slug)).to be_empty
        end
      end

      context "when the redirection is for a subdomain of an existing site" do
        it "does not create a new redirection" do
          expect(Redirection.find_by(url: "http://gabebw.com")).to be_present
          new_slug = "new"

          request.env["HTTP_REFERER"] = "https://www2.gabebw.com/bruh12"
          get action, params: { slug: new_slug }

          expect(Redirection.where(slug: new_slug)).to be_empty
        end
      end

      context "when using an existing slug" do
        it "shows a special page when the domain does not match" do
          cool = create(:redirection, slug: "cool", url: "https://cool.com")

          request.env["HTTP_REFERER"] = "http://NOT-COOL.com"
          get action, params: { slug: cool.slug }

          expect(response).to redirect_to(existing_slug_path(cool.slug))
        end

        it "does not show a special page if the domain matches" do
          cool = create(:redirection, slug: "cool", url: "https://cool.com/my/links")

          request.env["HTTP_REFERER"] = "http://www.COOL.com"
          get action, params: { slug: cool.slug }

          expect(response).to redirect_to(next_or_previous(action, cool))
        end
      end

      context "when the 'ring is closed" do
        it "does not create new sites when clicking #{action}" do
          allow(Rails.configuration).to receive(:closed).and_return(true)
          redirection_count = Redirection.count
          new_slug = "new"
          url = "http://example.com"

          request.env["HTTP_REFERER"] = url
          get action, params: { slug: new_slug }

          expect(Redirection.count).to eq redirection_count
        end

        it "redirects to our closed page when clicking #{action}" do
          allow(Rails.configuration).to receive(:closed).and_return(true)
          new_slug = "new"
          url = "http://example.com"

          request.env["HTTP_REFERER"] = url
          get action, params: { slug: new_slug }

          expect(response).to redirect_to(page_path("closed"))
        end

        it "allows existing sites to click #{action}" do
          allow(Rails.configuration).to receive(:closed).and_return(true)
          gabe = Redirection.find_by!(slug: "gabe")
          redirection = gabe.send(action)

          get action, params: { slug: gabe.slug }

          expect(response).to redirect_to(redirection.url)
        end
      end
    end
  end

  describe "GET :previous" do
    it "redirects to the previous site" do
      gabe = Redirection.find_by!(slug: "gabe")
      previous = Redirection.find_by!(next: gabe)

      get :previous, params: { slug: gabe.slug }

      expect(response).to redirect_to(previous.url)
    end
  end

  def next_or_previous(action, redirection)
    if action == :next
      redirection.next_url
    else
      redirection.previous_url
    end
  end
end
