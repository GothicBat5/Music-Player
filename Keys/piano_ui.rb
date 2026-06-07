# piano_ui.rb
# Handles all canvas drawing for the piano:

require 'fox16'
include Fox
require_relative 'piano_keys'
require_relative 'piano_style'

module PianoUI

  include PianoStyle

  # Module-level shorthand (can't assign constants inside methods in Ruby)
  S = PianoStyle

  def self.build_key_rects
    rects  = {}
    white_x = 0
    white_keys = PianoKeys::ALL_KEYS.select { |k| k[:type] == :white }


    white_keys.each do |k|
      id = "#{k[:note]}#{k[:octave]}"
      rects[id] = {
        x: white_x,
        y: 0,
        w: WHITE_KEY_WIDTH,
        h: WHITE_KEY_HEIGHT,
        type: :white
      }
      white_x += WHITE_KEY_WIDTH
    end


    # The "anchor" white key for each black key:
    #   C# anchors to C,  D# anchors to C (offset spans C+D),
    #   F# anchors to F,  G# anchors to F, A# anchors to F

    current_white_x = 0
    PianoKeys::ALL_KEYS.each do |k|
      if k[:type] == :white
        current_white_x += WHITE_KEY_WIDTH
      else
        id = "#{k[:note]}#{k[:octave]}"

        note = k[:note]

        # Offset from the white key that immediately precedes this black key
        # C# is 60% into C, so offset from C's left edge
        # D# is 40% into D, but we need its absolute x
        # Easiest: offset from the white key to its left (current_white_x - WHITE_KEY_WIDTH)
        left_white_x = current_white_x - WHITE_KEY_WIDTH
        frac = case note
               when "C#" then 0.60
               when "D#" then 0.60
               when "F#" then 0.60
               when "G#" then 0.60
               when "A#" then 0.60
               end
        bx = (left_white_x + WHITE_KEY_WIDTH * frac - BLACK_KEY_WIDTH / 2.0).round

        rects[id] = {
          x: bx,
          y: 0,
          w: BLACK_KEY_WIDTH,
          h: BLACK_KEY_HEIGHT,
          type: :black
        }
      end
    end

    rects
  end


  def self.draw(dc, key_rects, pressed_keys, frame_x, frame_y)
    # Translate all drawing by frame offset
    ox = frame_x
    oy = frame_y

    key_rects.each do |id, r|
      next unless r[:type] == :white
      pressed = pressed_keys.include?(id)

      x = ox + r[:x]
      y = oy + r[:y]
      w = r[:w]
      h = r[:h]

      # Key fill
      dc.foreground = pressed ? S::COLOR_WHITE_KEY_PRESSED : S::COLOR_WHITE_KEY
      dc.fillRectangle(x + 1, y + 1, w - 2, h - 2)

      # Right shadow strip (gives slight 3D depth)
      unless pressed
        dc.foreground = S::COLOR_WHITE_KEY_SHADOW
        dc.fillRectangle(x + w - 5, y + h / 2, 4, h / 2 - 4)
      end

      # Border
      dc.foreground = S::COLOR_WHITE_KEY_BORDER
      dc.drawRectangle(x, y, w, h)

      # Bottom rounded feel — draw a slightly lighter bar at very bottom
      dc.foreground = pressed ? S::COLOR_WHITE_KEY_BORDER : S::COLOR_WHITE_KEY
      dc.fillRectangle(x + 2, y + h - 6, w - 4, 5)
      dc.foreground = S::COLOR_WHITE_KEY_BORDER
      dc.drawRectangle(x + 1, y + h - 7, w - 2, 6)

      # Keyboard label (near bottom of white key)
      label = PianoKeys::KEY_LABELS[id]
      if label
        dc.foreground = pressed ? S::COLOR_WHITE_KEY_BORDER : S::COLOR_WHITE_LABEL
        # FXFont drawing — center horizontally
        dc.drawText(x + (w / 2) - 4, y + h - 14, label)
      end

      # Note name (smaller, above label)
      note_name = id.gsub(/\d/, '')  # strip octave number
      dc.foreground = S::COLOR_WHITE_LABEL
      dc.drawText(x + (w / 2) - 5, y + h - 26, note_name)
    end


    divider_x = ox + 7 * S::WHITE_KEY_WIDTH
    dc.foreground = S::COLOR_OCTAVE_LINE
    dc.drawLine(divider_x, oy, divider_x, oy + S::WHITE_KEY_HEIGHT)


    key_rects.each do |id, r|
      next unless r[:type] == :black
      pressed = pressed_keys.include?(id)

      x = ox + r[:x]
      y = oy + r[:y]
      w = r[:w]
      h = r[:h]

      # Shadow behind black key (gives lift effect)
      unless pressed
        dc.foreground = FXRGB(0, 0, 0)
        dc.fillRectangle(x + 2, y + 2, w, h + 4)
      end

      # Key fill
      dc.foreground = pressed ? S::COLOR_BLACK_KEY_PRESSED : S::COLOR_BLACK_KEY
      dc.fillRectangle(x, y, w, h)

      # Shine strip at top of black key
      unless pressed
        dc.foreground = S::COLOR_BLACK_KEY_SHINE
        dc.fillRectangle(x + 3, y + 2, w - 6, 12)
      end

      # Border
      dc.foreground = S::COLOR_BLACK_KEY_BORDER
      dc.drawRectangle(x, y, w, h)

      # Keyboard label on black key
      label = PianoKeys::KEY_LABELS[id]
      if label
        dc.foreground = pressed ? FXRGB(220, 190, 120) : S::COLOR_BLACK_LABEL
        dc.drawText(x + (w / 2) - 4, y + h - 8, label)
      end
    end

    dc.foreground = S::COLOR_FRAME
    dc.fillRectangle(0, 0, S::WINDOW_WIDTH, frame_y)


    dc.foreground = S::COLOR_FRAME_LIGHT
    dc.fillRectangle(0, frame_y - 3, S::WINDOW_WIDTH, 3)

    dc.fillRectangle(0, frame_y, frame_x, S::WHITE_KEY_HEIGHT)
    dc.fillRectangle(frame_x + S::CANVAS_WIDTH, frame_y, frame_x + 1, S::WHITE_KEY_HEIGHT)

    dc.foreground = S::COLOR_FRAME
    dc.fillRectangle(0, frame_y + S::WHITE_KEY_HEIGHT, S::WINDOW_WIDTH, S::FRAME_PAD_BOTTOM)
    dc.foreground = S::COLOR_FRAME_LIGHT
    dc.fillRectangle(0, frame_y + S::WHITE_KEY_HEIGHT, S::WINDOW_WIDTH, 3)
  end

end
