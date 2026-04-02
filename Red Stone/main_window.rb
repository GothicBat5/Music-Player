# frozen_string_literal: true

require 'fox16'
require_relative 'theme'
require_relative 'song_list'
require_relative 'controls'
require_relative 'player'
include Fox

class MainWindow < FXMainWindow
  WINDOW_W = 680
  WINDOW_H = 460

  def initialize(app)
    super(app, "Wavelength  ·  Music Player", width: WINDOW_W, height: WINDOW_H, opts: DECOR_ALL)

    self.backColor = Theme::BACKGROUND

    build_layout(app)
    wire_events
  end

  private

  def build_layout(app)
    root = FXHorizontalFrame.new(self, LAYOUT_FILL_X | LAYOUT_FILL_Y | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, hSpacing: 0)
    build_sidebar(root, app)
    build_main_panel(root, app)
  end

  def build_sidebar(parent, app)
    sidebar = FXVerticalFrame.new(parent, LAYOUT_FILL_Y | LAYOUT_FIX_WIDTH | FRAME_NONE, width: 240, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, vSpacing: 0)
    sidebar.backColor = Theme::SURFACE

    hdr = FXLabel.new(sidebar, "  Queue")
    hdr.textColor = Theme::TEXT_MUTED
    hdr.font = Theme.label_font(app)
    hdr.backColor = Theme::SURFACE
    hdr.padTop = 12
    hdr.padBottom = 6

    sep = FXHorizontalFrame.new(sidebar, LAYOUT_FILL_X | LAYOUT_FIX_HEIGHT | FRAME_NONE, height: 1)
    sep.backColor = Theme::BORDER

    @song_list = SongList.new(sidebar, app)
    @song_list.backColor = Theme::SURFACE
  end

  # Right main panel -------------------------------------------------------
  def build_main_panel(parent, app)
    panel = FXVerticalFrame.new(parent, LAYOUT_FILL_X | LAYOUT_FILL_Y | FRAME_NONE, padTop: 24, padBottom: 16, padLeft: 24, padRight: 24, vSpacing: 14)
    panel.backColor = Theme::BACKGROUND

    build_album_art(panel, app)
    build_track_info(panel, app)
    build_controls(panel, app)
    build_status_bar(panel, app)
  end

  def build_album_art(parent, app)
    wrapper = FXHorizontalFrame.new(parent, LAYOUT_FILL_X | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0)
    wrapper.backColor = Theme::BACKGROUND

    FXLabel.new(wrapper, "", opts: LAYOUT_FILL_X).backColor = Theme::BACKGROUND

    art = FXCanvas.new(wrapper, nil, 0, FRAME_NONE | LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT, width: 160, height: 160)
    art.backColor = Theme::ART_BG

    @album_art = art

    art.connect(SEL_PAINT) do |sender, sel, event|
      dc = FXDCWindow.new(sender, event)
      dc.foreground = Theme::ART_BG
      dc.fillRectangle(0, 0, sender.width, sender.height)

      cx = sender.width  / 2
      cy = sender.height / 2
      [66, 50, 34, 18].each do |r|
        dc.foreground = Theme::ART_BORDER
        dc.drawArc(cx - r, cy - r, r * 2, r * 2, 0, 360 * 64)
      end
      # Centre dot
      dc.foreground = Theme::ACCENT
      dc.fillArc(cx - 5, cy - 5, 10, 10, 0, 360 * 64)

      dc.end
    end

    FXLabel.new(wrapper, "", opts: LAYOUT_FILL_X).backColor = Theme::BACKGROUND
  end

  def build_track_info(parent, app)
    info = FXVerticalFrame.new(parent, LAYOUT_FILL_X | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, vSpacing: 4)
    info.backColor = Theme::BACKGROUND

    @track_label = FXLabel.new(info, "Select a track", opts: JUSTIFY_CENTER_X)
    @track_label.font      = Theme.title_font(app)
    @track_label.textColor = Theme::TEXT_PRIMARY
    @track_label.backColor = Theme::BACKGROUND

    @artist_label = FXLabel.new(info, "", opts: JUSTIFY_CENTER_X)
    @artist_label.font      = Theme.artist_font(app)
    @artist_label.textColor = Theme::TEXT_SECONDARY
    @artist_label.backColor = Theme::BACKGROUND
  end

  def build_controls(parent, app)
    @controls = Controls.new(parent, app)
    @controls.backColor = Theme::BACKGROUND
  end

  def build_status_bar(parent, app)
    bar = FXHorizontalFrame.new(parent, LAYOUT_FILL_X | FRAME_NONE, padTop: 6, padBottom: 0, padLeft: 0, padRight: 0)
    bar.backColor = Theme::BACKGROUND

    @status_label = FXLabel.new(bar, "Ready", opts: JUSTIFY_LEFT)
    @status_label.font = Theme.status_font(app)
    @status_label.textColor = Theme::STATUS_TEXT
    @status_label.backColor = Theme::BACKGROUND

    spacer = FXLabel.new(bar, "", opts: LAYOUT_FILL_X)
    spacer.backColor = Theme::BACKGROUND

    @state_badge = FXLabel.new(bar, "STOPPED")
    @state_badge.font = Theme.label_font(app)
    @state_badge.textColor = Theme::TEXT_MUTED
    @state_badge.backColor = Theme::BACKGROUND
  end

  def wire_events
    @player = Player.new

    @song_list.connect(SEL_COMMAND) do
      update_track_display
    end

    # Play
    @controls.play_btn.connect(SEL_COMMAND) do
      track = @song_list.selected_track
      if track
        @player.play(track[:title])
        @controls.play_btn.text  = "⏸  Pause"
        @status_label.text = "Playing  #{track[:title]}  ·  #{track[:artist]}"
        @state_badge.text = "PLAYING"
        @state_badge.textColor = Theme::ACCENT
      end
    end

    # Stop
    @controls.stop_btn.connect(SEL_COMMAND) do
      @player.stop
      @controls.play_btn.text  = "▶  Play"
      @status_label.text = "Stopped"
      @state_badge.text = "STOPPED"
      @state_badge.textColor = Theme::TEXT_MUTED
      @controls.progress_slider.value = 0
    end

    # Previous
    @controls.prev_btn.connect(SEL_COMMAND) do
      n = @song_list.count
      next_idx = [(@song_list.currentItem - 1), 0].max
      @song_list.currentItem = next_idx
      update_track_display
    end

    # Next
    @controls.next_btn.connect(SEL_COMMAND) do
      n = @song_list.count
      next_idx = [(@song_list.currentItem + 1), n - 1].min
      @song_list.currentItem = next_idx
      update_track_display
    end
  end

  def update_track_display
    track = @song_list.selected_track
    return unless track

    @track_label.text  = track[:title]
    @artist_label.text = track[:artist]
    @status_label.text = "#{track[:title]}  ·  #{track[:artist]}"
    @album_art.update  # repaint the vinyl graphic
  end
end
