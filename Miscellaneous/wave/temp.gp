# Temperature Monitoring Plot

# File: temperature_process.gp

# Set up output
set terminal pngcairo size 1200,800 enhanced font 'Verdana,12'
set output 'temperature_process.png'

# Titles and labels
set title "Temperature Monitoring of Chemical Process"
set xlabel "Time (minutes)"
set ylabel "Temperature (°C)"
set grid

# Axis ranges
set xrange [0:120]         
set yrange [20:100]        

# Styling
set key outside right top
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5  
set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5   
set style line 3 lc rgb '#009933' lt 2 lw 2             

# Reference lines
set arrow from 0,80 to 120,80 nohead lc rgb 'red' lw 1 dt 2
set label "Safety Threshold (80°C)" at 5,82 tc rgb 'red'

# Plot data
# Assume we have a file 'temperature.dat' with two columns:
# time(min)   temperature(°C)

plot "temperature.dat" using 1:2 with linespoints ls 1 title "Measured Temperature", \
     "temperature.dat" using 1:(80) with lines ls 3 title "Threshold Line", \
     "temperature.dat" using 1:(50+10*sin($1/10)) with lines ls 2 title "Model Prediction"
