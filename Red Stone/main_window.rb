# frozen_string_literal: true
# ruby player this

require 'fox16'
require_relative 'theme'
require_relative 'song_list'
require_relative 'controls'
require_relative 'player'
include Fox

class MainWindow < FXMainWindow
  WINDOW_W = 900
  WINDOW_H = 545

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
    sidebar = FXVerticalFrame.new(parent, LAYOUT_FILL_Y | LAYOUT_FIX_WIDTH | FRAME_NONE, width: 290, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, vSpacing: 0)
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

  def build_main_panel(parent, app)
    panel = FXVerticalFrame.new(parent, LAYOUT_FILL_X | LAYOUT_FILL_Y | FRAME_NONE, padTop: 28, padBottom: 18, padLeft: 32, padRight: 32, vSpacing: 16)
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

    art = FXCanvas.new(wrapper, nil, 0, FRAME_NONE | LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT, width: 180, height: 180)
    art.backColor = Theme::ART_BG
    @album_art = art

    art.connect(SEL_PAINT) do |sender, _sel, event|
      dc = FXDCWindow.new(sender, event)
      dc.foreground = Theme::ART_BG
      dc.fillRectangle(0, 0, sender.width, sender.height)

      cx = sender.width / 2
      cy = sender.height / 2
      [76, 58, 40, 22].each do |r|
        dc.foreground = Theme::ART_BORDER
        dc.drawArc(cx - r, cy - r, r * 2, r * 2, 0, 360 * 64)
      end
      dc.foreground = Theme::ACCENT
      dc.fillArc(cx - 6, cy - 6, 12, 12, 0, 360 * 64)
      dc.end
    end

    FXLabel.new(wrapper, "", opts: LAYOUT_FILL_X).backColor = Theme::BACKGROUND
  end

  def build_track_info(parent, app)
    info = FXVerticalFrame.new(parent, LAYOUT_FILL_X | FRAME_NONE, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, vSpacing: 4)
    info.backColor = Theme::BACKGROUND

    @track_label = FXLabel.new(info, "Select a track", opts: JUSTIFY_CENTER_X)
    @track_label.font = Theme.title_font(app)
    @track_label.textColor = Theme::TEXT_PRIMARY
    @track_label.backColor = Theme::BACKGROUND

    @artist_label = FXLabel.new(info, "", opts: JUSTIFY_CENTER_X)
    @artist_label.font = Theme.artist_font(app)
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

    # List selection: update track info panel
    @song_list.connect(SEL_COMMAND) do
      update_track_display
    end

    @controls.play_btn.connect(SEL_COMMAND) do
      track = @song_list.selected_track
      next unless track

      if @player.playing
        @player.stop
        @controls.play_btn.text = "▶  Play"
        @status_label.text = "Paused  ·  #{track[:title]}"
        @state_badge.text = "PAUSED"
        @state_badge.textColor = Theme::TEXT_SECONDARY
      else
        success = @player.play(track[:file])
        if success
          @controls.play_btn.text = "⏸  Pause"
          @status_label.text = "Playing  #{track[:title]}  ·  #{track[:artist]}"
          @state_badge.text = "PLAYING"
          @state_badge.textColor = Theme::ACCENT
        else
          @status_label.text = "⚠  File not found: #{track[:file]}"
          @state_badge.text = "ERROR"
          @state_badge.textColor = Theme::BTN_STOP_TXT
        end
      end
    end

    #Stop
    @controls.stop_btn.connect(SEL_COMMAND) do
      @player.stop
      @controls.play_btn.text = "▶  Play"
      @status_label.text = "Stopped"
      @state_badge.text = "STOPPED"
      @state_badge.textColor = Theme::TEXT_MUTED
      @controls.progress_slider.value  = 0
    end

    #Previous track
    @controls.prev_btn.connect(SEL_COMMAND) do
      next_idx = [(@song_list.currentItem - 1), 0].max
      @song_list.currentItem = next_idx
      update_track_display
      auto_play_current
    end

    #Next track
    @controls.next_btn.connect(SEL_COMMAND) do
      next_idx = [(@song_list.currentItem + 1), @song_list.count - 1].min
      @song_list.currentItem = next_idx
      update_track_display
      auto_play_current
    end

    #Volume slider
    @controls.volume_slider.connect(SEL_CHANGED) do
      level = @controls.volume_slider.value
      @controls.volume_label.text = "#{level}%"
      @player.set_volume(level)
    end

    # Cleanup ffplay process when window is closed
    connect(SEL_CLOSE) do
      @player.cleanup
      getApp.exit(0)
    end
  end

  def update_track_display
    track = @song_list.selected_track
    return unless track

    @track_label.text = track[:title]
    @artist_label.text = track[:artist]
    @status_label.text = "#{track[:title]}  ·  #{track[:artist]}"
    @album_art.update
  end

  def auto_play_current
    track = @song_list.selected_track
    return unless track

    success = @player.play(track[:file])
    if success
      @controls.play_btn.text = "⏸  Pause"
      @status_label.text = "Playing  #{track[:title]}  ·  #{track[:artist]}"
      @state_badge.text = "PLAYING"
      @state_badge.textColor = Theme::ACCENT
    else
      @status_label.text = "⚠  File not found: #{track[:file]}"
      @state_badge.text = "ERROR"
      @state_badge.textColor = Theme::BTN_STOP_TXT
    end
  end
end
