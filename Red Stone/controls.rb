# frozen_string_literal: true

require 'fox16'
require_relative 'theme'
include Fox

class Controls < FXVerticalFrame
  attr_reader :play_btn, :stop_btn, :prev_btn, :next_btn,
              :progress_slider, :volume_slider,
              :elapsed_label, :remaining_label, :volume_label

  def initialize(parent, app)
    super(parent, LAYOUT_FILL_X | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, vSpacing: 10)

    build_progress_row(app)
    build_button_row(app)
    build_volume_row(app)
  end

  private

  def build_progress_row(app)
    row = FXHorizontalFrame.new(self, LAYOUT_FILL_X | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, hSpacing: 6)

    @elapsed_label = FXLabel.new(row, "0:00")
    @elapsed_label.textColor = Theme::TEXT_SECONDARY
    @elapsed_label.font = Theme.time_font(app)
    @elapsed_label.backColor  = Theme::BACKGROUND

    @progress_slider = FXSlider.new(row, nil, 0, LAYOUT_FILL_X | SLIDER_HORIZONTAL | FRAME_SUNKEN)
    @progress_slider.range = 0..100
    @progress_slider.value = 0
    @progress_slider.backColor = Theme::TRACK_BG

    @remaining_label = FXLabel.new(row, "3:45")
    @remaining_label.textColor = Theme::TEXT_SECONDARY
    @remaining_label.font = Theme.time_font(app)
    @remaining_label.backColor = Theme::BACKGROUND
  end

  def build_button_row(app)
    row = FXHorizontalFrame.new(self, LAYOUT_FILL_X | PACK_UNIFORM_WIDTH | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, hSpacing: 8)

    @prev_btn = styled_button(row, app, "◀◀  Prev", Theme::BTN_PREV_NEXT_BG, Theme::BTN_PREV_NEXT_TXT)

    @play_btn = styled_button(row, app, "▶  Play", Theme::BTN_PLAY_BG, Theme::BTN_PLAY_TXT, bold: true)

    @stop_btn = styled_button(row, app, "■  Stop", Theme::BTN_STOP_BG, Theme::BTN_STOP_TXT)

    @next_btn = styled_button(row, app, "Next  ▶▶", Theme::BTN_PREV_NEXT_BG, Theme::BTN_PREV_NEXT_TXT)
  end

  def build_volume_row(app)
    row = FXHorizontalFrame.new(self, LAYOUT_FILL_X | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, hSpacing: 6)

    icon = FXLabel.new(row, "VOL")
    icon.textColor = Theme::TEXT_MUTED
    icon.font  = Theme.label_font(app)
    icon.backColor = Theme::BACKGROUND

    @volume_slider = FXSlider.new(row, nil, 0, LAYOUT_FIX_WIDTH | SLIDER_HORIZONTAL | FRAME_SUNKEN, width: 120)
    @volume_slider.range = 0..100
    @volume_slider.value = 80
    @volume_slider.backColor = Theme::TRACK_BG

    @volume_label = FXLabel.new(row, "80%")
    @volume_label.textColor = Theme::ACCENT
    @volume_label.font = Theme.label_font(app)
    @volume_label.backColor = Theme::BACKGROUND

    @volume_slider.connect(SEL_CHANGED) do
      @volume_label.text = "#{@volume_slider.value}%"
    end
  end

  def styled_button(parent, app, text, bg, fg, bold: false)
    btn = FXButton.new(parent, text, opts: BUTTON_NORMAL | LAYOUT_FILL_X)
    btn.backColor = bg
    btn.textColor = fg
    btn.font = bold ? Theme.button_font(app) : Theme.font(app, size: 10)
    btn.padTop = 8
    btn.padBottom = 8
    btn
  end
end
