#!/usr/bin/env ruby

require 'pathname'

def run(cmd)
  puts cmd
  %x{#{cmd}}
end

while(1) do
  run("#{Pathname.new(File.dirname(__FILE__)).realpath}/dirs.rb")
  sleep(55) # seconds
end
