set title "Musical Tone: A4 (440 Hz)"
set xlabel "Time (seconds)"
set ylabel "Amplitude"
set grid

# Define the sine wave for 440 Hz = A4 note
f(x) = sin(2*pi*440*x)

# Plot one millisecond of the waveform
plot [0:0.001] f(x) with lines title "A4 sine wave"
