class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == "test"
    # rootViewController = UIViewController.alloc.init
    # rootViewController.title = 'AFNetworking101'
    # rootViewController.view.backgroundColor = UIColor.whiteColor
    #
    # navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)
    #
    # @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # @window.rootViewController = navigationController
    # @window.makeKeyAndVisible
    #
    get_json_request

    true
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
