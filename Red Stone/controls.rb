require 'fox16'
require_relative 'theme'
include Fox

class Controls < FXVerticalFrame
  def initialize(parent, app)
    super(parent, LAYOUT_FILL_X | PACK_UNIFORM_WIDTH)

    play = FXButton.new(self, "Play Song")
    play.backColor = Theme::BUTTON_PLAY
    play.textColor = Theme::BUTTON_TEXT
    play.font = Theme.button_font(app)
    play.padTop = play.padBottom = 10

    stop = FXButton.new(self, "Stop Song")
    stop.backColor = Theme::BUTTON_STOP
    stop.textColor = Theme::BUTTON_TEXT
    stop.font = Theme.button_font(app)
    stop.padTop = stop.padBottom = 10
  end
end
