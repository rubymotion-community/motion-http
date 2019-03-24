class AppDelegate < PM::Delegate
  def on_load(app, options)
    return true if RUBYMOTION_ENV == 'test'
    open MainScreen
  end
end

class MainScreen < PM::TableScreen
  # TEST_HOST = 'https://jsonplaceholder.typicode.com'
  TEST_HOST = 'http://localhost:4567'

  def table_data
    [{
      cells: [
        {
          title: 'GET /posts',
          action: -> {
            Motion::HTTP.get("#{TEST_HOST}/posts") do |response|
              if response.success?
                puts "first post: #{response.object.first.inspect}"
              else
                puts response.body
              end
            end
          }
        }, {
          title: 'GET /comments?postId=1',
          action: -> {
            Motion::HTTP.get("#{TEST_HOST}/comments", params: { postId: 1 }) do |response|
              if response.success?
                puts "first comment: #{response.object.first.inspect}"
              else
                puts response.body
              end
            end
          }
        }, {
          title: 'POST /posts (JSON post body)',
          action: -> {
            Motion::HTTP.post("#{TEST_HOST}/posts", json: { title: "My new post", body: "Such a great blog post!" }) do |response|
              if response.success?
                puts "new post response object: #{response.object.inspect}"
              else
                puts response.body
              end
            end
          }
        }, {
          title: 'POST /posts (form data)',
          action: -> {
            Motion::HTTP.post("#{TEST_HOST}/posts", form: { title: "My new post", body: "Such a great blog post!" }) do |response|
              if response.success?
                puts "new post response object: #{response.object.inspect}"
              else
                puts response.body
              end
            end
          }
        }
      ]
    }]
  end
end
