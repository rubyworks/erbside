#!/usr/bin/env ruby

watch /qed\/.*?\.rdoc/ do
  File.open('QED.rdoc', 'w') do |f|
    Dir['qed/*.rdoc'].sort.each do |qed_file|
      f << File.read(qed_file)
      f << "\n\n"
    end
  end
end

