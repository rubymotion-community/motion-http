class MainActivity < Android::App::Activity
  TEST_HOST = 'https://jsonplaceholder.typicode.com'
  # TEST_HOST = 'http://localhost:4567'
  # TEST_HOST = 'http://192.168.0.5:4567'

  def onCreate(savedInstanceState)
    super
    HTTP.application_context = getApplicationContext

    view = Android::Widget::TextView.new(self)
    view.text = "Hello World!"
    self.contentView = view

    test_requests
  end

  def test_requests
    # HTTP.get("#{TEST_HOST}/posts") do |response|
    #   if response.success?
    #     puts "first post: #{response.object.first.inspect}"
    #   else
    #     puts response.body
    #   end
    # end
    # HTTP.get("#{TEST_HOST}/comments", params: { postId: 1 }) do |response|
    #   puts "comments: #{response.inspect}"
    #   if response.success?
    #     puts "first comment: #{response.object.first.inspect}"
    #   else
    #     puts response.body
    #   end
    # end
    # HTTP.post("#{TEST_HOST}/posts", headers: { 'X-Custom' => 'something' }, form: { title: "My new post", body: "Such a great blog post!" }) do |response|
    #   puts "new post response: #{response.inspect}"
    #   if response.success?
    #     puts "new post response object: #{response.object.inspect}"
    #   else
    #     puts response.body
    #   end
    # end
      if response.success?
        puts "new post response object: #{response.object.inspect}"
      else
        puts response.body
      end
    end
  end
end
