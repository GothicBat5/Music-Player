loop do

  puts "=== KO Ratio Calculator ===\n"

  print "Wins: "
  wins = gets.to_i

  print "Losses: "
  losses = gets.to_i

  print "Draws: "
  draws = gets.to_i

  print "KO Wins: "
  ko = gets.to_i

  puts

  if ko > wins

    puts "Error: KO wins cannot exceed total wins."

  elsif wins == 0

    puts "KO Ratio: 0.00%"
    puts "Reason: No wins recorded."

  else

    ratio = (ko.to_f / wins) * 100

    puts "Record: #{wins}-#{losses}-#{draws}"
    puts "\nKO Ratio: #{format('%.2f', ratio)}%"

  end

  puts "\nX to exit or press ENTER to continue>"
  choice = gets.chomp

  break if choice.downcase == "x"

  puts

end

puts "\nProgram Ended."
