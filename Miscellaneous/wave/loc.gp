# Audio waveform example in Gnuplot
set title "Sine Wave - A4 (440 Hz)"
set xlabel "Time (seconds)"
set ylabel "Amplitude"
set grid

# Sampling rate (samples per second)
fs = 44100

# Frequency of the note (Hz)
f = 440

# Define the sine wave function
sine_wave(t) = sin(2 * pi * f * t)

# Plot the waveform for the first 0.01 seconds
plot [t=0:0.01] sine_wave(t) with lines lw 2 lc rgb "blue" title "440 Hz sine"

# Frequency spectrum example in Gnuplot
set title "Frequency Spectrum of Audio Signal"
set xlabel "Frequency (Hz)"
set ylabel "Magnitude"
set grid

# Suppose we have FFT data in a file 'spectrum.dat'
# Format: frequency   magnitude
# Example rows:
# 440 0.8
# 880 0.4
# 1320 0.2

plot "spectrum.dat" using 1:2 with impulses lw 2 lc rgb "red" title "FFT Spectrum"
