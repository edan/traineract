#!/usr/bin/env ruby

box_file_name = ARGV[0]
if box_file_name.nil?
  puts "usage: ./detect_errors PATH_TO_BOX_FILE [PATH_TO_TRAINING_TEXT_FILE]"
  Process.exit 1
end

box_file = File.read(box_file_name)

File.write("#{box_file_name}.bak", box_file)

training_text_file = ARGV[1].nil? ? './training_text.txt' : ARGV[1]
training_text = File.read(training_text_file)
training_text = training_text.gsub(' ','').chomp.split('')

character_count = training_text.count
box_coordinates = box_file.split("\n")

vertical_diff = "" 

box_coordinates.each_with_index do |bc, idx|
  vertical_diff << "#{bc.split.first} #{training_text[idx]} #{idx}\n"
end

puts "comparing #{box_file_name} to #{training_text_file}"

if character_count > box_coordinates.count
  puts vertical_diff
  raise "more characters #{character_count} than boxes #{box_coordinates.count}!"
elsif box_coordinates.count > character_count
  puts vertical_diff
  raise "more boxes #{box_coordinates.count} than characters #{character_count}!"
end

misses = {}

box_coordinates.each_with_index do |bc, idx|
  correct_char = training_text[idx]
  bc_array = bc.split(' ')

  if bc_array.first != correct_char
    misses[idx] = {correct_char => bc}
    bc_array[0] = correct_char
    box_coordinates[idx] = bc_array.join(' ')
  end

end

if misses.empty?
  puts "wow your box file is correct!"
else
  puts "auto-corrected #{misses.count} misses:"
  puts misses

  File.write("#{box_file_name}", box_coordinates.join("\n") + "\n")

  puts "rewrote #{box_file_name}"
end

Process.exit 0
