# frozen_string_literal: true

require 'fox16'
require_relative 'theme'
include Fox

class SongList < FXList
  TRACKS = [
    { title: "Sanctuary", artist: "Joji"},
    { title: "ASMR Ear Whisper", artist: "Unknown" },
    { title: "K", artist: "Cigarette After Sex"},
    { title: "FANCY", artist: "TWICE"},
    { title: "Tadow", artist: "Masego"},
    { title: "Glimpse of Us", artist: "Joji"},
    { title: "SLOW DANCING IN THE DARK", artist: "Joji"},
    { title: "Die For You", artist: "The Weeknd"},
  ].freeze

  def initialize(parent, app)
    super(parent,
          opts: LIST_SINGLESELECT | LAYOUT_FILL_Y | LAYOUT_FILL_X | FRAME_NONE)

    self.backColor = Theme::LIST_BG
    self.textColor = Theme::LIST_TEXT
    self.font = Theme.list_font(app)
    self.numVisible = TRACKS.size

    TRACKS.each_with_index do |track, i|
      num = format("%02d", i + 1)
      appendItem("  #{num}  #{track[:title]}  –  #{track[:artist]}")
    end

    self.currentItem = 0
  end

  def selected_track
    idx = currentItem
    idx >= 0 ? TRACKS[idx] : nil
  end
end
