#!/usr/bin/env ruby

require 'pathname'

def run(cmd)
  STDERR.puts "#{__FILE__}: #{cmd}"
  %x{#{cmd}}
end

while(1) do
  run("#{Pathname.new(File.dirname(__FILE__)).realpath}/dirs.rb")
end
