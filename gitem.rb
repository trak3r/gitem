#!/usr/bin/env ruby

# gitem - git email
# use git-commit-notifier gem to email git commit diffs

def run(cmd)
  puts cmd
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

while(true) do

run("git reset --hard")

heads, origins = ls_remote # to get the list of branches

origins.keys.sort.each do |branch|
  run("git checkout -t origin/#{branch}") unless heads[branch]
  run("git checkout #{branch}")
  run("git fetch origin")
end

heads, origins = ls_remote # again, now that we've fetched the updated hashes

origins.keys.sort.each do |branch|
  unless heads[branch] == origins[branch]
    run("git checkout #{branch}")
    run("git pull origin #{branch}")
    run("git-commit-notifier ~/git-commit-notifier.yml #{heads[branch]} #{origins[branch]} #{branch}")
  end
end

sleep(55) # seconds

end
