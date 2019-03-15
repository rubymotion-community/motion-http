# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
$:.unshift("~/.rubymotion/rubymotion-templates")

template = ENV['template'] || 'ios'
# ENV["output"] ||= "tap" # spec output style
require "motion/project/template/#{template}"
require './lib/motion-http'

begin
  require 'bundler'
  require 'motion/project/template/gem/gem_tasks'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'motion-http'

  if template == 'android'
    # app.api_version = '23'
    # app.target_api_version = '23'
    # app.archs = ['armv5s', 'x86']
    app.files.delete_if { |path| path.is_a?(String) && path.start_with?('./app/cocoa') }
  else
    # Only iOS
    app.files.delete_if {|path| path.is_a?(String) && path.start_with?('./app/android') }
    app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  end
end

def invoke_rake(platform, task)
  trace = Rake.application.options.trace == true

  template = platform.to_s == 'android' ? 'android' : 'cocoa'
  system "template=#{platform} rake \"#{task}\" #{trace ? '--trace' : ''}" or exit 1
end

desc 'Build the project, then run the simulator'
task 'ios' do
  invoke_rake 'ios', 'default'
end
namespace 'ios' do
  desc 'Run the specs'
  task 'spec' do
    invoke_rake 'ios', 'spec'
  end
end

desc 'Build the project, then run the emulator'
task('android') { invoke_rake 'android', 'default' }

namespace 'android' do
  task('device') { invoke_rake 'android', 'device' }
  task('clean')  { invoke_rake 'android', 'clean' }
  task('spec')   { invoke_rake 'android', 'spec' }
  task('spec:emulator') { invoke_rake 'android', 'spec:emulator' }
  task('spec:device')   { invoke_rake 'android', 'spec:device' }
end
