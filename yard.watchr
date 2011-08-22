#!/usr/bin/env ruby

watch /qed\/.*?\.rdoc/ do
  File.open('DEMOS.rdoc', 'w') do |f|
    f << "= <i>DEMONSTRATIONS</i>\n\n"
    Dir['qed/*.rdoc'].sort.each do |qed_file|
      f << File.read(qed_file)
      f << "\n\n"
    end
  end
end

