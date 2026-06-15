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

  # Validation checks
  if wins < 0 || losses < 0 || draws < 0 || ko < 0
    puts "Error: Values cannot be negative."
    
  elsif ko > wins
    puts "Error: KO wins cannot exceed total wins."
    
  elsif wins == 0
    puts "KO Ratio: 0.00%"
    puts "Reason: No wins recorded."
    
  else
    ratio = (ko.to_f / wins) * 100
    puts "Record: #{wins}-#{losses}-#{draws}"
    puts "\nKO Ratio: #{format('%.2f', ratio)}%"
    
    total_fights = wins + losses + draws
    
    
    puts "\nTotal fights: #{total_fights}"
  end

  puts "\nX to exit or press ENTER to continue>"
  
  
  choice = gets.chomp
  break if choice.downcase == "x"

  puts
  
end

puts "\nProgram Ended."
