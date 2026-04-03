# frozen_string_literal: true
require 'fox16'
require_relative 'theme'
include Fox

class SongList < FXList
  TRACKS = [ #this is all must be in the same file folder, make sure to create a sub folder inside your IDE
    { title: "Sanctuary", artist: "Joji", file: "music/Joji - Sanctuary.mp3"},
    { title: "Die For You", artist: "Joji", file: "music/Joji - Die For you.mp3"},
    { title: "Love Us Again", artist: "Joji", file: "music/Joji - Love us again.mp3"},
    { title: "Kung Fu Hustle Soundtrack", artist: "Zhi Yao Wei Ni Huo Yi Tian", file: "music/zhi_yao.mp3"},
    { title: "Lilith", artist: "Saint Avangeline", file: "music/Lilith.mp3"},
    { title: "Spin the Wheel", artist: "Mick Wingert", file: "music/Mick Wingert - Spin The Wheel.mp3"},
    { title: "Daft Punk", artist: "Pentatonix", file: "music/Pentatonix - Daft Punk.mp3"},
    { title: "Dancing with your Ghost", artist: "Sasha Alex Sloan", file: "music/Sasha Alex Sloan - Dancing With Your Ghost.mp3"},
  ].freeze

  def initialize(parent, app)
    super(parent, opts: LIST_SINGLESELECT | LAYOUT_FILL_Y | LAYOUT_FILL_X | FRAME_NONE)

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
