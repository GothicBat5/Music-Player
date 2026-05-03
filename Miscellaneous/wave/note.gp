set title "Harmonics of a Note"
set xlabel "Time (seconds)"
set ylabel "Amplitude"
set grid

# Fundamental frequency 
f1(x) = sin(2*pi*261.63*x)
# First harmonic (2x frequency)
f2(x) = 0.5*sin(2*pi*2*261.63*x)
# Second harmonic (3x frequency)
f3(x) = 0.33*sin(2*pi*3*261.63*x)

# Combined waveform
f(x) = f1(x) + f2(x) + f3(x)

plot [0:0.01] f1(x) with lines title "Fundamental", \
               f2(x) with lines title "1st Harmonic", \
               f3(x) with lines title "2nd Harmonic", \
               f(x) with lines lw 2 title "Combined Sound"
