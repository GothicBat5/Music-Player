require 'fox16'
include Fox

module Theme
  BACKGROUND      = FXRGB(255, 180, 180)
  LIST_BG         = FXRGB(255, 140, 140)
  LIST_SELECTED   = FXRGB(120, 180, 80)
  LIST_TEXT       = FXRGB(255, 255, 255)

  BUTTON_PLAY     = FXRGB(120, 200, 160)
  BUTTON_STOP     = FXRGB(230, 60, 90)
  BUTTON_TEXT     = FXRGB(255, 255, 255)

  STATUS_TEXT     = FXRGB(249, 57, 124)

  def self.list_font(app)
    FXFont.new(app, "Segoe UI", 11)
  end

  def self.button_font(app)
    FXFont.new(app, "Segoe UI", 12, FONTWEIGHT_BOLD)
  end

  def self.status_font(app)
    FXFont.new(app, "Segoe UI", 10)
  end
end
