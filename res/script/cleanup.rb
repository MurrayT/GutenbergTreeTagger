#!/usr/bin/env ruby

abort "Incorrect usage" unless ARGV.length == 3 and ARGV.all?

infilename = ARGV[0]
outfilename = ARGV[1]
forbiddenfilename = ARGV[2]

for filename in [infilename, forbiddenfilename] do
    abort "File #{filename} not found" unless File.file? filename
end

forbidden = File.open(forbiddenfilename, "r").read.split

File.open(outfilename, "w") do |outfile|
    File.open(infilename, "r").each do |line|
        thisline = line.strip.split
        outfile.puts thisline.join "\t" unless forbidden.include? thisline[1]
    end
end

oldline=`wc -l #{infilename}`.split[0].to_i
newline=`wc -l #{outfilename}`.split[0].to_i

puts "Finished cleaning #{infilename}, #{oldline - newline} lines removed"
