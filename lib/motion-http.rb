# encoding: utf-8

unless defined?(Motion::Project::Config)
  raise "This gem is only intended to be used in a RubyMotion project."
end

lib_dir_path = File.dirname(File.expand_path(__FILE__))
Motion::Project::App.setup do |app|
  app.files.unshift(*Dir.glob(File.join(lib_dir_path, "common/**/*.rb")))

  case Motion::Project::App.template
  when :android
    require "motion-gradle"
    app.files.unshift(*Dir.glob(File.join(lib_dir_path, "android/**/*.rb")))
    app.gradle do
      dependency "com.squareup.okhttp3:okhttp:3.9.0"
    end
  when :ios, :tvos, :osx, :watchos, :'ios-extension'
    app.files.unshift(*Dir.glob(File.join(lib_dir_path, "cocoa/**/*.rb")))
  else
    raise "Project template #{Motion::Project::App.template} not supported by motion-http"
  end
end
