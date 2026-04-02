require 'fox16'
require_relative 'theme'
require_relative 'song_list'
require_relative 'controls'
include Fox

class MainWindow < FXMainWindow
  def initialize(app)
    super(app, "Classic Music Player", width: 520, height: 420)

    self.backColor = Theme::BACKGROUND

    main = FXHorizontalFrame.new(self, LAYOUT_FILL_X | LAYOUT_FILL_Y)

    left = FXVerticalFrame.new(main, LAYOUT_FILL_Y | LAYOUT_FIX_WIDTH, width: 300)

    SongList.new(left, app)

    right = FXVerticalFrame.new(main, LAYOUT_FILL_Y | LAYOUT_FILL_X | FRAME_NONE, padding: 20)

    album = FXLabel.new(right, nil)
    album.justify = JUSTIFY_CENTER_X
    album.backColor = FXRGB(249, 57, 124)
    album.width = 200
    album.height = 200

    status = FXLabel.new(right, "Playing: x x x")
    status.textColor = Theme::STATUS_TEXT
    status.font = Theme.status_font(app)

    Controls.new(right, app)
  end
end
# frozen_string_literal: true

