# gem install midilib

require 'midilib/sequence'
require 'midilib/consts'
include MIDI

seq = Sequence.new()
track = Track.new()
seq.tracks << track

track.events << Tempo.new(Tempo.bpm_to_mpq(120))

melody = [60, 62, 64, 65, 67]
time = 0

melody.each do |note|
    track.events << NoteOn.new(0, note, 100, time)
    track.events << NoteOff.new(0, note, time + 240)
    time += 240
end

File.open("Sanctuary.mid", "wb") { |file| seq.write(file) }

puts "Done"
