# frozen_string_literal: true

require 'fox16'
include Fox

module Theme

  BACKGROUND = FXRGB(18,  18,  22)   # near-black base
  SURFACE = FXRGB(28,  28,  34)   # card / panel surface
  SURFACE_ALT = FXRGB(36,  36,  44)   # slightly lifted surface
  BORDER = FXRGB(48,  48,  58)   # subtle separator

  # Warm amber accent
  ACCENT = FXRGB(255, 171,  64)  # amber highlight
  ACCENT_DIM = FXRGB(180, 110,  20)  # dimmed accent

  # Text
  TEXT_PRIMARY = FXRGB(240, 238, 230)  # warm off-white
  TEXT_SECONDARY = FXRGB(150, 145, 135)  # muted label
  TEXT_MUTED = FXRGB( 90,  87,  80)  # very muted

  # List
  LIST_BG = SURFACE
  LIST_SELECTED_BG = FXRGB( 48,  44,  30)  # amber-tinted selection
  LIST_TEXT = TEXT_PRIMARY
  LIST_SELECTED_TXT = ACCENT

  # Buttons
  BTN_PLAY_BG = ACCENT
  BTN_PLAY_TXT = FXRGB( 20, 15, 0)
  BTN_STOP_BG = FXRGB( 60, 25, 30)
  BTN_STOP_TXT = FXRGB(255, 100, 110)
  BTN_PREV_NEXT_BG = SURFACE_ALT
  BTN_PREV_NEXT_TXT = TEXT_PRIMARY

  # Album art placeholder
  ART_BG = FXRGB( 38,  34,  48)
  ART_BORDER = FXRGB( 70,  60,  90)

  # Progress / volume track
  TRACK_BG = FXRGB( 45,  43,  55)
  TRACK_FILL = ACCENT

  # Status bar
  STATUS_BG = FXRGB( 22,  22,  28)
  STATUS_TEXT = TEXT_SECONDARY
  
  def self.font(app, size: 10, bold: false)
    weight = bold ? FONTWEIGHT_BOLD : FONTWEIGHT_NORMAL
    # Try modern fonts, fallback gracefully
    %w[Segoe\ UI Helvetica\ Neue Arial].each do |name|
      begin
        f = FXFont.new(app, name, size, weight)
        return f
      rescue
        next
      end
    end
    FXFont.new(app, "helvetica", size, weight)
  end

  def self.title_font(app)
    font(app, size: 13, bold: true)
  end

  def self.artist_font(app)
    font(app, size: 10)
  end

  def self.button_font(app)
    font(app, size: 11, bold: true)
  end

  def self.list_font(app)
    font(app, size: 10)
  end

  def self.label_font(app)
    font(app, size: 9)
  end

  def self.status_font(app)
    font(app, size: 9)
  end

  def self.time_font(app)
    font(app, size: 9)
  end
end
