#!/usr/bin/env ruby

require 'pathname'

def run(cmd)
  puts cmd
  %x{#{cmd}}
end

Dir.foreach('.') do |dir|
  next if dir.chars.to_a[0] == '.'
  run("cd '#{dir}' && '#{Pathname.new(File.dirname(__FILE__)).realpath}/gitem.rb'")
end
