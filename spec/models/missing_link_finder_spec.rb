require "rails_helper"

RSpec.describe MissingLinkFinder do
  describe "#run" do
    let(:redirection) { Redirection.first! }
    let(:next_link) { "https://hotlinewebring.club/#{redirection.slug}/next" }
    let(:prev_link) { "https://hotlinewebring.club/#{redirection.slug}/previous" }

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

    it "follows redirects" do
      body = <<~BODY
        <a href="https://hotlinewebring.club/#{redirection.slug}/next">next</a>
        <a href="https://hotlinewebring.club/#{redirection.slug}/previous">
          previous
        </a>
      BODY
      new_url = "https://example.com/cool"
      stub_request(:get, redirection.url).to_return(
        status: 301,
        headers: { Location: new_url },
      )
      stub_request(:get, new_url).to_return(body: body)

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

    it "returns a :good status even when links are in <iframe>s" do
      iframe_relative_previous = <<~IFRAME
        <a href="https://hotlinewebring.club/#{redirection.slug}/previous">
          previous
        </a>
      IFRAME
      iframe_next = <<~IFRAME
        <a href="https://hotlinewebring.club/#{redirection.slug}/next">next</a>
      IFRAME
      body = <<~BODY
        <iframe src="iframe_relative_previous">
        <iframe src="#{redirection.url}/iframe_next">
      BODY

      stub_request(:get, redirection.url).to_return(body: body)
      stub_request(:get, "#{redirection.url}/iframe_relative_previous")
        .to_return(body: iframe_relative_previous)
      stub_request(:get, "#{redirection.url}/iframe_next")
        .to_return(body: iframe_next)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :good })
    end

    it "returns a :good status even when links are in <frame>s" do
      frame_previous = <<~FRAME
        <a href="https://hotlinewebring.club/#{redirection.slug}/previous">
          previous
        </a>
      FRAME
      frame_relative_next = <<~FRAME
        <a href="https://hotlinewebring.club/#{redirection.slug}/next">next</a>
      FRAME
      body = <<~BODY
        <frame src="#{redirection.url}/frame_previous">
        <frame src="frame_relative_next">
      BODY

      stub_request(:get, redirection.url).to_return(body: body)
      stub_request(:get, "#{redirection.url}/frame_previous")
        .to_return(body: frame_previous)
      stub_request(:get, "#{redirection.url}/frame_relative_next")
        .to_return(body: frame_relative_next)

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

    it "returns :not_found status for websites that return a 404" do
      stub_request(:get, redirection.url).to_return(body: "abc", status: 404)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({ status: :not_found })
    end

    it "returns :error status for websites that errored but are probably online" do
      openssl_error = OpenSSL::SSL::SSLError.new(
        "SSL_connect returned=1 errno=0 state=error: certificate verify failed (certificate has expired)"
      )
      stub_request(:get, redirection.url).to_raise(openssl_error)

      result = MissingLinkFinder.new(redirection).run

      expect(result).to eq({
        status: :error,
        error: "#{openssl_error.class}: #{openssl_error.message}",
      })
    end

    context "when links are xlink:href" do
      it "returns a good status when the page has both links" do
        body = <<~BODY
          <svg>
            <a xlink:href="#{next_link}">next</a>
            <a xlink:href="#{prev_link}">prev</a>
          </svg>
        BODY
        stub_request(:get, redirection.url).to_return(body: body)

        result = MissingLinkFinder.new(redirection).run

        expect(result).to eq({ status: :good })
      end

      it "returns a bad status when the page has only a 'next' link" do
        body = <<~BODY
          <svg>
            <a xlink:href="#{next_link}">next</a>
          </svg>
        BODY
        stub_request(:get, redirection.url).to_return(body: body)

        result = MissingLinkFinder.new(redirection).run

        expect(result).to eq(status: :missing_links, missing: ["prev"])
      end

      it "returns a bad status when the page has only a 'previous' link" do
        body = <<~BODY
          <svg>
            <a xlink:href="#{prev_link}">prev</a>
          </svg>
        BODY
        stub_request(:get, redirection.url).to_return(body: body)

        result = MissingLinkFinder.new(redirection).run

        expect(result).to eq(status: :missing_links, missing: ["next"])
      end
    end
  end
end
