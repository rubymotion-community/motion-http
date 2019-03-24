describe 'PUT Requests' do
  extend WebStub::SpecHelpers

  before do
    disable_network_access!
    HTTP.logger.disable!
    @response = nil
  end

  it 'can make simple PUT requests' do
    stub = stub_request(:put, 'http://example.com/widgets')

    HTTP.put('http://example.com/widgets')

    wait(0.1) { expect(stub).to be_requested }
  end

  it 'can submit a JSON request body' do
    stub = stub_request(:put, 'http://example.com/widgets')
  
    stub.with_callback do |headers, body|
      @request_headers = headers
      @request_body = body
    end

    HTTP.put('http://example.com/widgets', json: { name: 'Foobar Widget' })
  
    wait(0.1) do
      expect(stub).to be_requested
      expect(@request_headers['content-type']).to eq 'application/json'
      expect(@request_body).to eq '{"name":"Foobar Widget"}'
    end
  end

  it 'can submit form data as request body' do
    stub = stub_request(:put, 'http://example.com/widgets')
  
    stub.with_callback do |headers, body|
      @request_headers = headers
      @request_body = body
    end

    HTTP.put('http://example.com/widgets', form: { name: 'Foobar Widget' })

    wait(0.5) do
      expect(stub).to be_requested
      expect(@request_headers['content-type']).to eq 'application/x-www-form-urlencoded'
      expect(@request_body).to eq 'name' => 'Foobar Widget' # webstub converts the form data to a hash for us
    end
  end

  it 'can specify custom content type' do
    stub = stub_request(:put, 'http://example.com/widgets')
  
    stub.with_callback do |headers, body|
      @request_headers = headers
      @request_body = body
    end

    headers = { 'Content-Type' => 'application/vnd.api+json' }
    json = { name: 'Foobar Widget' }
    HTTP.put('http://example.com/widgets', headers: headers, json: json)

    wait(0.5) do
      expect(stub).to be_requested
      expect(@request_headers['content-type']).to eq 'application/vnd.api+json'
      expect(@request_body).to eq '{"name":"Foobar Widget"}'
    end
  end

  it 'returns a response with the correct status code, headers, and parsed JSON object' do
    stub = stub_request(:put, 'http://example.com/widgets').
      to_return(status_code: 201, json: { widget: { id: '123', name: 'Foobar Widget' } })

    HTTP.put('http://example.com/widgets') do |response|
      @response = response
    end

    wait(0.1) do
      expect(stub).to be_requested
      expect(@response.success?).to be_true
      expect(@response.status_code).to eq 201
      expect(@response.headers['Content-Type']).to eq 'application/json'
      expect(@response.body).to eq '{"widget":{"id":"123","name":"Foobar Widget"}}'
      expect(@response.object).to eq 'widget' => { 'id' => '123', 'name' => 'Foobar Widget' }
    end
  end
end
