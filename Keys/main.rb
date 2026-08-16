# main.rb
require 'fox16'
include Fox
require 'set'
require_relative 'piano_keys'
require_relative 'piano_style'
require_relative 'piano_ui'
require_relative 'piano_input'

begin
  require 'fiddle'

  user32 = Fiddle.dlopen('user32')
  shcore = Fiddle.dlopen('shcore')

  begin
    Fiddle::Function.new(user32['SetProcessDPIAware'],[], Fiddle::TYPE_INT).call
    
  rescue
  end

rescue
end


def play_note(note)

  file = "sounds/#{note}.mp3"

  system("start /B ffplay -nodisp -autoexit \"#{file}\" >nul 2>&1")

end

app = FXApp.new

window = FXMainWindow.new(app, "Ruby Piano",
  width: PianoStyle::WINDOW_WIDTH,
  height: PianoStyle::WINDOW_HEIGHT
)


main = FXVerticalFrame.new(window, LAYOUT_FILL_X | LAYOUT_FILL_Y,
  padLeft: 0, padRight: 0, padTop: 0, padBottom: 0
)

# Status label bar (mahogany coloured background)
label_frame = FXHorizontalFrame.new(main, LAYOUT_FILL_X,
  padLeft: 12, padRight: 12, padTop: 6, padBottom: 6,
  backColor: PianoStyle::COLOR_LABEL_BG
)

label = FXLabel.new(label_frame, "Press keyboard keys or click piano keys to play",
  nil,
  LAYOUT_FILL_X | JUSTIFY_LEFT,
  backColor: PianoStyle::COLOR_LABEL_BG,
  foreColor: PianoStyle::COLOR_LABEL_TEXT
)

canvas_frame = FXVerticalFrame.new(main, LAYOUT_FILL_X | LAYOUT_FILL_Y,
  padLeft: PianoStyle::FRAME_PAD_SIDE,
  padRight: PianoStyle::FRAME_PAD_SIDE,
  padTop: PianoStyle::FRAME_PAD_TOP,
  padBottom: PianoStyle::FRAME_PAD_BOTTOM,
  backColor: PianoStyle::COLOR_FRAME
)

canvas = FXCanvas.new(canvas_frame, nil, 0,
  LAYOUT_FILL_X | LAYOUT_FILL_Y,
  width: PianoStyle::CANVAS_WIDTH,
  height: PianoStyle::CANVAS_HEIGHT
)


key_rects = PianoUI.build_key_rects
pressed_keys = Set.new


canvas.connect(SEL_PAINT) do |sender, sel, event|
  FXDCWindow.new(canvas, event) do |dc|
    # Clear canvas background
    dc.foreground = PianoStyle::COLOR_FRAME
    dc.fillRectangle(0, 0, canvas.width, canvas.height)

    PianoUI.draw(dc, key_rects, pressed_keys, 0, 0)
  end
end


PianoInput.attach(window: window, canvas: canvas,
  key_rects: key_rects,
  pressed_keys: pressed_keys,
  label: label,
  frame_x: 0,
  frame_y: 0,
  on_play: ->(id) {
    # id is e.g. "C4", "F#5" — maps to sounds/C4.mp3 etc.
    play_note(id)
  }
)

notes = {

  "C" => KEY_a,
  "D" => KEY_s,
  "E" => KEY_d,
  "F" => KEY_f,
  "G" => KEY_g,
  "A" => KEY_h,
  "B" => KEY_j
}

app.create

window.show(PLACEMENT_SCREEN)

app.run
