# piano_style.rb
# Visual constants: colors, dimensions, fonts for the piano UI

require 'fox16'
include Fox

module PianoStyle

  WHITE_KEY_WIDTH = 52
  WHITE_KEY_HEIGHT = 200
  BLACK_KEY_WIDTH = 32
  BLACK_KEY_HEIGHT = 125
  KEY_BORDER = 2
  CORNER_RADIUS = 4


  CANVAS_WIDTH = 14 * WHITE_KEY_WIDTH   # 728
  CANVAS_HEIGHT = WHITE_KEY_HEIGHT + 40  # extra room for frame top/bottom


  FRAME_PAD_TOP = 20
  FRAME_PAD_SIDE = 16
  FRAME_PAD_BOTTOM = 20

  # Window dimensions (frame wraps canvas)
  WINDOW_WIDTH = CANVAS_WIDTH + (FRAME_PAD_SIDE * 2)
  WINDOW_HEIGHT = CANVAS_HEIGHT + FRAME_PAD_TOP + FRAME_PAD_BOTTOM + 60  # +60 for label bar



  COLOR_FRAME = FXRGB(58,  28,  15)
  COLOR_FRAME_LIGHT = FXRGB(92,  48,  26)


  COLOR_WHITE_KEY = FXRGB(255, 252, 240)
  COLOR_WHITE_KEY_PRESSED = FXRGB(230, 210, 160)
  COLOR_WHITE_KEY_BORDER = FXRGB(160, 140, 110)
  COLOR_WHITE_KEY_SHADOW = FXRGB(200, 185, 150)


  COLOR_BLACK_KEY = FXRGB(28,  22,  18)
  COLOR_BLACK_KEY_PRESSED = FXRGB(70,  55,  35)
  COLOR_BLACK_KEY_SHINE = FXRGB(70,  60,  50)
  COLOR_BLACK_KEY_BORDER = FXRGB(10,   8,   6)


  COLOR_LABEL_BG = FXRGB(40,  20,  10)
  COLOR_LABEL_TEXT = FXRGB(220, 190, 120)

  # Key label text (the keyboard shortcut hint printed on each key)
  COLOR_WHITE_LABEL = FXRGB(140, 115,  75)
  COLOR_BLACK_LABEL = FXRGB(160, 140,  90)

  COLOR_OCTAVE_LINE = FXRGB(180, 140,  80)

  #   C# = 0.6 into C
  #   D# = 0.4 into D  (but measured from its own white key start)
  #   F# = 0.55 into F
  #   G# = 0.5  into G
  #   A# = 0.45 into A

  BLACK_KEY_OFFSETS = {
    "C#" => (WHITE_KEY_WIDTH * 0.60 - BLACK_KEY_WIDTH / 2.0).round,
    "D#" => (WHITE_KEY_WIDTH * 0.40 - BLACK_KEY_WIDTH / 2.0 + WHITE_KEY_WIDTH).round,
    "F#" => (WHITE_KEY_WIDTH * 0.55 - BLACK_KEY_WIDTH / 2.0),
    "G#" => (WHITE_KEY_WIDTH * 0.50 - BLACK_KEY_WIDTH / 2.0 + WHITE_KEY_WIDTH).round,
    "A#" => (WHITE_KEY_WIDTH * 0.45 - BLACK_KEY_WIDTH / 2.0 + WHITE_KEY_WIDTH * 2).round,
  }.freeze

end
