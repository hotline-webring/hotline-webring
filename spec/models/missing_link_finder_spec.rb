require "rails_helper"

RSpec.describe MissingLinkFinder do
  describe "#run" do
    let(:redirection) { Redirection.first! }

    it "returns a :good status when the website has both links" do
      body = <<~BODY
        <a href="https://hotlinewebring.club/#{redirection.slug}/next">next</a>
        <a href="https://hotlinewebring.club/#{redirection.slug}/previous">
          previous
        </a>
      BODY
      stub_request(:get, redirection.url).to_return(body: body)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :good })
    end

    it "returns a :good status when the website has both links, encoded" do
      slash = "&#x2F;"
      host = "https:#{slash}#{slash}hotlinewebring.club"
      body = <<~BODY
        <a href="#{host}#{slash}#{redirection.slug}#{slash}next">
          next
        </a>
        <a href="#{host}#{slash}#{redirection.slug}#{slash}previous">
          previous
        </a>
      BODY
      stub_request(:get, redirection.url).to_return(body: body)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :good })
    end

    it "returns a :good status when the website has both links, encoded lowercase" do
      slash = "&#x2F;".downcase
      host = "https:#{slash}#{slash}hotlinewebring.club"
      body = <<~BODY
        <a href="#{host}#{slash}#{redirection.slug}#{slash}next">
          next
        </a>
        <a href="#{host}#{slash}#{redirection.slug}#{slash}previous">
          previous
        </a>
      BODY
      stub_request(:get, redirection.url).to_return(body: body)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :good })
    end

    it "follows redirects" do
      final_url = "https://cool.example"
      stub_request(:get, redirection.url).
        to_return(status: 302, headers: { "Location" => final_url })
      stub_request(:get, final_url).to_return(body: "abc")

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :missing_links, missing: %w(next prev) })
    end

    it "follows permanent redirects" do
      final_url = "https://cool.example"
      stub_request(:get, redirection.url).
        to_return(status: 301, headers: { "Location" => final_url })
      stub_request(:get, final_url).to_return(body: "abc")

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :missing_links, missing: %w(next prev) })
    end

    it "returns :offline status for websites that are no longer online" do
      stub_request(:get, redirection.url).to_raise(SocketError)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :offline })
    end

    it "returns :offline status for websites that return a 404" do
      stub_request(:get, redirection.url).to_return(body: "abc", status: 404)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :offline })
    end

    it "returns :error status for websites that errored but are probably online" do
      openssl_error = OpenSSL::SSL::SSLError.new(
        'SSL_connect returned=1 errno=0 state=error: certificate verify failed (certificate has expired)'
      )
      stub_request(:get, redirection.url).to_raise(openssl_error)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({
        status: :error,
        error: "#{openssl_error.class}: #{openssl_error.message}"
      })
    end
  end
end
