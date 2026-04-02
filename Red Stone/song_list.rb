require 'fox16'
require_relative 'theme'
include Fox

class SongList < FXList
  def initialize(parent, app)
    super(parent, opts: LIST_SINGLESELECT | LAYOUT_FILL_Y | LAYOUT_FILL_X)

    self.backColor = Theme::LIST_BG
    self.textColor = Theme::LIST_TEXT
    self.font = Theme.list_font(app)
    self.numVisible = 6

    appendItem("Sanctuary - Joji")
    appendItem("ASMR Ear Whisper")
    appendItem("K - Cigarette After Sex")
    appendItem("FANCY - TWICE")
    appendItem("Tadow - Masego")

    self.currentItem = 1   # Static selected item
  end
end
