#!/usr/bin/env ruby
require "open3"

expected_error, original_code = File.read('5.txt').split('---')

0.upto original_code.length do |i|
  code = original_code[0...i].to_s + original_code[i+1..-1].to_s
  File.write('tmp/temp__del.rb', code)
  # binding.irb
  o, e, s = Open3.capture3("ruby tmp/temp__del.rb")
  # binding.irb
  if e.include? expected_error.strip
    puts "!!!solved!!!"
    puts code
    exit
  end
end

threads = []
0.upto original_code.length do |i|
  threads << Thread.start(i) do |i|
    (" "..."~").each do |char|
      code = original_code[0...i].to_s + char + original_code[i..-1].to_s
      File.write("tmp/temp__add_#{i}.rb", code)
      o, e, s = Open3.capture3("ruby tmp/temp__add_#{i}.rb")
      if e.include? expected_error.strip
        puts "!!!solved!!!"
        puts code
        exit
      end
    end
  end
end
threads.each(&:join)
