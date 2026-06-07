# piano_input.rb
# Wires up keyboard and mouse input to the piano canvas.
# Handles key press/release for visual feedback and note playback.

require 'fox16'
include Fox
require_relative 'piano_keys'
require_relative 'piano_style'

module PianoInput


  def self.attach(window:, canvas:, key_rects:, pressed_keys:, label:, on_play:, frame_x:, frame_y:)


    key_to_id = PianoKeys::KEY_MAP.invert

    # Keyboard press
    window.connect(SEL_KEYPRESS) do |sender, sel, event|
      id = key_to_id[event.code]
      if id && !pressed_keys.include?(id)
        pressed_keys.add(id)
        label.text = "♪  #{id}  —  #{note_display(id)}"
        on_play.call(id)
        canvas.update  # trigger repaint
      end
    end

    # Keyboard release
    window.connect(SEL_KEYRELEASE) do |sender, sel, event|
      id = key_to_id[event.code]
      if id
        pressed_keys.delete(id)
        label.text = "Press keyboard keys or click piano keys to play"
        canvas.update
      end
    end


    canvas.connect(SEL_LEFTBUTTONPRESS) do |sender, sel, event|
      # Adjust for frame offset
      mx = event.win_x - frame_x
      my = event.win_y - frame_y

      id = hit_test(mx, my, key_rects)
      if id && !pressed_keys.include?(id)
        pressed_keys.add(id)
        label.text = "♪  #{id}  —  #{note_display(id)}"
        on_play.call(id)
        canvas.update
      end
    end


    canvas.connect(SEL_LEFTBUTTONRELEASE) do |sender, sel, event|
      mx = event.win_x - frame_x
      my = event.win_y - frame_y

      id = hit_test(mx, my, key_rects)
      if id
        pressed_keys.delete(id)
        label.text = "Press keyboard keys or click piano keys to play"
        canvas.update
      end
    end


    canvas.connect(SEL_MOTION) do |sender, sel, event|

      unless event.state & 0x0100 != 0
        unless pressed_keys.empty?
          pressed_keys.clear
          canvas.update
        end
      end
    end

  end


  def self.hit_test(mx, my, key_rects)

    key_rects.each do |id, r|
      next unless r[:type] == :black
      if mx >= r[:x] && mx <= r[:x] + r[:w] &&
         my >= r[:y] && my <= r[:y] + r[:h]
        return id
      end
    end


    key_rects.each do |id, r|
      next unless r[:type] == :white
      if mx >= r[:x] && mx <= r[:x] + r[:w] &&
         my >= r[:y] && my <= r[:y] + r[:h]
        return id
      end
    end

    nil
  end

  def self.note_display(id)
    meta = PianoKeys.all_with_meta.find { |k| k[:id] == id }
    return id unless meta
    "#{meta[:note]}#{meta[:octave]}  (#{meta[:freq]} Hz)"
  end

end
