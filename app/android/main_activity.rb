class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
    view = Android::Widget::TextView.new(self)
    view.text = "Hello World!"
    self.contentView = view

    get_json_request
  end

  def get_json_request
    Motion::HTTP.get("https://jsonplaceholder.typicode.com/posts") do |response|
      puts "posts: #{response.inspect}"
      if response.success?
        puts "first post: #{response.object.first.inspect}"
      else
        puts response.body
      end
    end
    Motion::HTTP.get("https://jsonplaceholder.typicode.com/comments", postId: 1) do |response|
      puts "comments: #{response.inspect}"
      if response.success?
        puts "first comment: #{response.object.first.inspect}"
      else
        puts response.body
      end
    end
    Motion::HTTP.post("https://jsonplaceholder.typicode.com/posts", title: "My new post", body: "Such a great blog post!") do |response|
      puts "new post response: #{response.inspect}"
      if response.success?
        puts "new post response object: #{response.object.inspect}"
      else
        puts response.body
      end
    end
  end
end
