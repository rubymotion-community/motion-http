describe 'GET Requests' do
  extend WebStub::SpecHelpers

  before do
    disable_network_access!
    HTTP.logger.disable!
    @response = nil
  end

  it 'can make simple GET requests' do
    stub = stub_request(:get, 'http://example.com')

    HTTP.get('http://example.com')

    wait(0.1) { expect(stub).to be_requested }
  end

  it 'encodes URL params' do
    stub = stub_request(:get, 'http://example.com?user%5Bname%5D=George+Washington')

    params = { user: { name: 'George Washington' } }
    HTTP.get('http://example.com', params: params)

    wait(0.1) { expect(stub).to be_requested }
  end

  it 'returns a response with the correct status code, headers, and parsed json object' do
    stub = stub_request(:get, 'http://example.com/posts').
      to_return(json: { posts: [{ title: 'The great foobar' }] })

    HTTP.get('http://example.com/posts') do |response|
      @response = response
    end

    wait(0.1) do
      expect(stub).to be_requested
      expect(@response.success?).to be_true
      expect(@response.status_code).to eq 200
      expect(@response.headers['Content-Type']).to eq 'application/json'
      expect(@response.body).to eq '{"posts":[{"title":"The great foobar"}]}'
      expect(@response.object).to eq 'posts' => [{ 'title' => 'The great foobar' }]
    end
  end

end
