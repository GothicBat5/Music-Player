# fix bug, time incorrect, better input!

puts "=== Ruby Alarm Calculator ===\n"

current_time = Time.now

puts "Current time: #{current_time.strftime("%I:%M:%S %p")}"

puts "How many minutes from now should the alarm ring?"
print "Input: "
minutes = gets.to_i

alarm_time = current_time + (minutes * 60)

puts "\nAlarm set!"
puts "Current time: #{current_time.strftime("%I:%M:%S %p")}"
puts "Alarm time:   #{alarm_time.strftime("%I:%M:%S %p")}"
