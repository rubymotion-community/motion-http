describe Motion::HTTP do
  extend WebStub::SpecHelpers
  disable_network_access!

  describe "#get" do
    it "makes a GET request" do
      stub = stub_request(:get, "http://example.com")

      Motion::HTTP.get("http://example.com") do |response|
        resume
      end

      wait_max 1 { stub.should.be.requested }
    end

    it "encodes URL params" do
      stub = stub_request(:get, "http://example.com?name=George%20Washington")

      Motion::HTTP.get("http://example.com", name: "George Washington") do |response|
        resume
      end

      wait_max 1 { stub.should.be.requested }
    end

    it "returns a response with the correct status code, headers, and parsed json object" do
      stub = stub_request(:get, "https://api.example.com/posts").
        to_return(json: { posts: [{ title: "The great foobar" }] })

      Motion::HTTP.get("https://api.example.com/posts") do |response|
        @response = response
        resume
      end

      wait_max 1 do
        stub.should.be.requested
        @response.status_code.should == 200
        @response.headers["Content-Type"].should == "application/json"
        @response.object.should == { "posts" => [{ "title" => "The great foobar" }] }
      end
    end
  end

  describe "#post" do
    it "makes a POST request" do
      stub = stub_request(:post, "http://example.com/widgets")

      Motion::HTTP.post("http://example.com/widgets") do |response|
        resume
      end

      wait_max 1 { stub.should.be.requested }
    end

    it "sends the correct request headers and body" do
      stub = stub_request(:post, "http://example.com/widgets").
        to_return(status_code: 201, json: { widget: { id: "123", name: "Foobar Widget" } })
    
      # stub.with_callback do |headers, body|
      #   @request_headers = headers
      #   @request_body = body
      # end

      Motion::HTTP.post("http://example.com/widgets", name: "Foobar Widget") do |response|
        @response = response
        resume
      end
    
      wait_max 1 do
        stub.should.be.requested
        # TODO: figure out how to stub/assert request body
      end
    end

    it "returns a response with the correct status code, headers, and parsed json object" do
      stub = stub_request(:post, "http://example.com/widgets").
        to_return(status_code: 201, json: { widget: { id: "123", name: "Foobar Widget" } })

      Motion::HTTP.post("http://example.com/widgets") do |response|
        @response = response
        resume
      end

      wait_max 1 do
        stub.should.be.requested
        @response.status_code.should == 201
        @response.headers["Content-Type"].should == "application/json"
        @response.object.should == { "widget" => { "id" => "123", "name" => "Foobar Widget" } }
      end
    end
  end
end
