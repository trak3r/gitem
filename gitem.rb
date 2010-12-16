#!/usr/bin/env ruby

def run(cmd)
  STDERR.puts "#{__FILE__}: #{cmd}"
  %x{#{cmd}}
end

def ls_remote
  origins = {}
  heads = {}
  ls_remote = `git ls-remote .`
  lines = ls_remote.split("\n")
  lines.each do |line|
    columns = line.split
    hash = columns[0]
    path = columns[1]
    parts = path.split('/')
    branch = parts[-1]
    source = parts[-2]
    unless 'HEAD' == branch # special case
      if 'origin' == source
        origins[branch] = hash
      elsif 'heads' == source
        heads[branch] = hash
      else
        puts "WTF do I do with source '#{source}' from '#{line}'?"
      end
    end
  end
  [ heads, origins ]
end

run("git reset --hard")

heads, origins = ls_remote # to get the list of branches

origins.keys.sort.each do |branch|
  run("git checkout -t origin/#{branch}") unless heads[branch]
  run("git checkout #{branch}")
  run("git reset --hard origin/#{branch}")
  run("git fetch origin")
  sleep(11) # seconds, don't spam github and get blacklisted
end

heads, origins = ls_remote # again, now that we've fetched the updated hashes

origins.keys.sort.each do |branch|
  unless heads[branch] == origins[branch]
    run("git checkout #{branch}")
    run("git pull origin #{branch}")
    sleep(3) # seconds, don't spam github and get blacklisted
    run("git-commit-notifier ~/git-commit-notifier.yml #{heads[branch]} #{origins[branch]} #{branch}")
  end
end
