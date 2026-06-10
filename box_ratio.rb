puts "=== KO Ratio Calculator ==="

print "Wins: "
wins = gets.to_i

print "Draws: "
draws = gets.to_i

print "Losses: "
losses = gets.to_i

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
