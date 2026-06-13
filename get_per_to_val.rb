# A is what percent of B? 

print "A: "
a = gets.to_f

print "B: "
b = gets.to_f

result = (a / b) * 100

puts "\n#{a} is #{format('%.2f', result)}% of #{b}"
