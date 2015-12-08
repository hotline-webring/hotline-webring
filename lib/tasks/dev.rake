if Rails.env.development? || Rails.env.test?
  require "factory_girl"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods

      create(:redirection, slug: "adarsh", url: "http://adarsh.io")
      create(:redirection, slug: "thorncp", url: "http://thorn.co")
      create(:redirection, slug: "foxed", url: "http://alexfox.me")
    end
  end
end
