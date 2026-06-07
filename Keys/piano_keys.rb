# piano_keys.rb
# for a 2-octave piano (C4 to B5): 14 white keys + 10 black keys

require 'fox16'
include Fox

module PianoKeys


  A4_FREQ = 440.0
  A4_MIDI = 69


  ALL_KEYS = [

    { note: "C",  octave: 4, type: :white  },
    { note: "C#", octave: 4, type: :black  },
    { note: "D",  octave: 4, type: :white  },
    { note: "D#", octave: 4, type: :black  },
    { note: "E",  octave: 4, type: :white  },
    { note: "F",  octave: 4, type: :white  },
    { note: "F#", octave: 4, type: :black  },
    { note: "G",  octave: 4, type: :white  },
    { note: "G#", octave: 4, type: :black  },
    { note: "A",  octave: 4, type: :white  },
    { note: "A#", octave: 4, type: :black  },
    { note: "B",  octave: 4, type: :white  },
    { note: "C",  octave: 5, type: :white  },
    { note: "C#", octave: 5, type: :black  },
    { note: "D",  octave: 5, type: :white  },
    { note: "D#", octave: 5, type: :black  },
    { note: "E",  octave: 5, type: :white  },
    { note: "F",  octave: 5, type: :white  },
    { note: "F#", octave: 5, type: :black  },
    { note: "G",  octave: 5, type: :white  },
    { note: "G#", octave: 5, type: :black  },
    { note: "A",  octave: 5, type: :white  },
    { note: "A#", octave: 5, type: :black  },
    { note: "B",  octave: 5, type: :white  },
  ].freeze

  # Keyboard mappings: "NoteOctave" => FOX key constant

  KEY_MAP = {

    "C4"  => KEY_a,
    "D4"  => KEY_s,
    "E4"  => KEY_d,
    "F4"  => KEY_f,
    "G4"  => KEY_g,
    "A4"  => KEY_h,
    "B4"  => KEY_j,


    "C5"  => KEY_k,
    "D5"  => KEY_l,
    "E5"  => KEY_semicolon,
    "F5"  => KEY_apostrophe,
    "G5"  => KEY_Return,
    "A5"  => KEY_bracketright,
    "B5"  => KEY_backslash,


    "C#4" => KEY_w,
    "D#4" => KEY_e,
    "F#4" => KEY_t,
    "G#4" => KEY_y,
    "A#4" => KEY_u,


    "C#5" => KEY_i,
    "D#5" => KEY_o,
    "F#5" => KEY_p,
    "G#5" => KEY_bracketleft,
    "A#5" => KEY_minus,
  }.freeze


  KEY_LABELS = {

    "C4"  => "A", "D4"  => "S", "E4"  => "D",
    "F4"  => "F", "G4"  => "G", "A4"  => "H", "B4"  => "J",
    "C5"  => "K", "D5"  => "L", "E5"  => ";",
    "F5"  => "'", "G5"  => "↵", "A5"  => "]", "B5"  => "\\",
    "C#4" => "W", "D#4" => "E", "F#4" => "T",
    "G#4" => "Y", "A#4" => "U",
    "C#5" => "I", "D#5" => "O", "F#5" => "P",
    "G#5" => "[", "A#5" => "-",
  }.freeze


  NOTE_SEMITONES = {

    "C" => 0, "C#" => 1, "D" => 2, "D#" => 3,
    "E" => 4, "F"  => 5, "F#" => 6, "G"  => 7,
    "G#" => 8, "A" => 9, "A#" => 10, "B" => 11
  }.freeze

  def self.frequency(note, octave)
    midi = (octave + 1) * 12 + NOTE_SEMITONES[note]
    A4_FREQ * (2.0 ** ((midi - A4_MIDI) / 12.0))
  end


  def self.all_with_meta
    ALL_KEYS.map do |k|
      id = "#{k[:note]}#{k[:octave]}"
      k.merge(
        id: id,
        freq: frequency(k[:note], k[:octave]).round(2),
        key: KEY_MAP[id],
        label: KEY_LABELS[id]
      )
    end
  end

end
