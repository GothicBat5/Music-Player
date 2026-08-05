# ins midilib, apl get install aubio 

require 'midilib/sequence'
require 'midilib/consts'
include MIDI

audio_file = "Sanctuary.mp4"

pitches = 'aubiopitch -1 #{audio_files} -s -p yin'
notes = []
time = 0

pitches.each_line do |line|
    t, freq, conf = line.split.map(&:to_f)
    next if freq <= 0 || conf < 0.8
    
    midi_note = (69 + 12 * Math.log2(freq / 440.0))
    notes << [midi_note, t]
end

seq = Sequence.new()
track = Track.new()
seq.tracks << track

track.events << Tempo.new(Tempo.bpm_to_mpq(120))

last_time = 0

notes.each do |note, t|
    ticks = ((t - last_time) * 480).to_i
    track.events << NoteOn.new(0, note, 100, last_time * 480)
    track.events << NoteOff.new(0, note, (last_time + 0.5) * 480)
    last_time = t
end

File.open("Sanctuary.mid", "wb") { |file| seq.write(file) }

puts "Done"
