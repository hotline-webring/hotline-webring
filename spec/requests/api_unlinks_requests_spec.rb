require "rails_helper"

RSpec.describe "API unlink requests" do
  describe "Creating" do
    context "if API token is incorrect" do
      it "returns a 401 status code" do
        redirection = Redirection.find_by!(slug: "gabe")

        post api_redirection_unlinks_path(redirection.slug)

        expect(response.status).to eq 401
        expect(Redirection.find_by(slug: redirection.slug)).not_to be_nil
        expect(BlockedReferrer.count).to eq 0
      end
    end

    it "unlinks the redirection" do
      redirection = create(:redirection, url: "https://foobar.neocities.org")

      post api_redirection_unlinks_path(redirection.slug),
           headers: {
             Authorization: "Bearer #{ApiController::API_TOKEN}",
           }

      expect(response.status).to eq 201
      expect(JSON.parse(response.body)["success"]).to eq true
      expect(Redirection.find_by(slug: redirection.slug)).to be_nil
    end

    it "does not block the redirection" do
      redirection = create(:redirection, url: "https://foobar.neocities.org")

      post api_redirection_unlinks_path(redirection.slug),
           headers: {
             Authorization: "Bearer #{ApiController::API_TOKEN}",
           }

      expect(BlockedReferrer.count).to eq 0
    end
  end
end
