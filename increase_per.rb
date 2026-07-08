# Origianl = 100, New = 150, = 50% increased! 
print "Original value: "
original = gets.chomp.to_f

print "New value: "
new_value = gets.chomp.to_f

increase = new_value - original
percentage = (increase / original) * 100

puts "\nIncrease: #{increase}"
puts "\nPercentage increase: #{percentage.round(2)}%"
