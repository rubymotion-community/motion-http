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
            HTTP.get("#{TEST_HOST}/posts") do |response|
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
            HTTP.get("#{TEST_HOST}/comments", params: { postId: 1 }) do |response|
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
            HTTP.post("#{TEST_HOST}/posts", json: { title: "My new post", body: "Such a great blog post!" }) do |response|
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
            HTTP.post("#{TEST_HOST}/posts", form: { title: "My new post", body: "Such a great blog post!" }) do |response|
              if response.success?
                puts "new post response object: #{response.object.inspect}"
              else
                puts response.body
              end
            end
          }
        }, {
          title: 'GET /basic_auth',
          action: -> {
            # HTTP.basic_auth('admin', 'letmein')
            HTTP.basic_auth('admin', 'badpass')
                .get("#{TEST_HOST}/basic_auth") do |response|
              if response.success?
                puts "successfully authenticated!"
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
