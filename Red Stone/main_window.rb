# main_window.rb

require 'fox16'
require_relative 'theme'
require_relative 'song_list'
require_relative 'controls'
require_relative 'player'
include Fox

class MainWindow < FXMainWindow
  WINDOW_W = 900
  WINDOW_H = 545
  POLL_INTERVAL = 500
  ART_INTERVAL  = 40   # ~25 fps for the spinning rings

  def initialize(app)
    super(app, "Wavelength  ·  Music Player", width: WINDOW_W, height: WINDOW_H, opts: DECOR_ALL)

    self.backColor = Theme::BACKGROUND

    @rotation_angle = 0.0   # degrees, drives the animated rings
    @art_spinning   = false

    build_layout(app)
    wire_events
  end

  private

  def build_layout(app)
    root = FXHorizontalFrame.new(self, LAYOUT_FILL_X | LAYOUT_FILL_Y | FRAME_NONE,
                                 padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, hSpacing: 0)
    build_sidebar(root, app)
    build_main_panel(root, app)
  end

  def build_sidebar(parent, app)
    sidebar = FXVerticalFrame.new(parent, LAYOUT_FILL_Y | LAYOUT_FIX_WIDTH | FRAME_NONE,
                                  width: 290, padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, vSpacing: 0)
    sidebar.backColor = Theme::SURFACE

    hdr = FXLabel.new(sidebar, "  Queue")
    hdr.textColor  = Theme::TEXT_MUTED
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
    panel = FXVerticalFrame.new(parent, LAYOUT_FILL_X | LAYOUT_FILL_Y | FRAME_NONE,
                                padTop: 28, padBottom: 18, padLeft: 32, padRight: 32, vSpacing: 16)
    panel.backColor = Theme::BACKGROUND

    build_album_art(panel, app)
    build_track_info(panel, app)
    build_controls(panel, app)
    build_status_bar(panel, app)
    build_shortcuts_hint(panel, app)
  end

  # Album art — concentric rings that rotate while playing

  def build_album_art(parent, app)
    wrapper = FXHorizontalFrame.new(parent, LAYOUT_FILL_X | FRAME_NONE,
                                    padTop: 0, padBottom: 0, padLeft: 0, padRight: 0)
    wrapper.backColor = Theme::BACKGROUND

    FXLabel.new(wrapper, "", opts: LAYOUT_FILL_X).backColor = Theme::BACKGROUND

    art = FXCanvas.new(wrapper, nil, 0,
                       FRAME_NONE | LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT,
                       width: 180, height: 180)
    art.backColor = Theme::ART_BG
    @album_art = art

    art.connect(SEL_PAINT) do |sender, _sel, event|
      dc = FXDCWindow.new(sender, event)
      dc.foreground = Theme::ART_BG
      dc.fillRectangle(0, 0, sender.width, sender.height)

      cx = sender.width  / 2
      cy = sender.height / 2
      # Each ring is offset by a different fraction of the rotation angle,
      # creating a staggered, organic feel.  We approximate an arc at an
      # angular offset by drawing a full ellipse shifted slightly — FOX's
      # drawArc doesn't support rotation of the ellipse axes, so we shift
      # the centre of each ring along a tiny orbit instead.
      radii   = [76, 58, 40, 22]
      offsets = [1.0, 0.7, 0.5, 0.3]   # how much each ring "wobbles"

      radii.each_with_index do |r, i|
        angle_rad = (@rotation_angle + i * 22) * Math::PI / 180.0
        orbit     = offsets[i] * 4      # max pixel drift
        ox = (Math.cos(angle_rad) * orbit).round
        oy = (Math.sin(angle_rad) * orbit).round

        dc.foreground = Theme::ART_BORDER
        dc.drawArc(cx - r + ox, cy - r + oy, r * 2, r * 2, 0, 360 * 64)
      end

      # Centre dot — pulses colour when playing
      dot_color = @art_spinning ? Theme::ACCENT : Theme::ART_BORDER
      dc.foreground = dot_color
      dc.fillArc(cx - 6, cy - 6, 12, 12, 0, 360 * 64)

      dc.end
    end

    FXLabel.new(wrapper, "", opts: LAYOUT_FILL_X).backColor = Theme::BACKGROUND
  end

  def build_track_info(parent, app)
    info = FXVerticalFrame.new(parent, LAYOUT_FILL_X | FRAME_NONE,
                               padTop: 0, padBottom: 0, padLeft: 0, padRight: 0, vSpacing: 4)
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
    bar = FXHorizontalFrame.new(parent, LAYOUT_FILL_X | FRAME_NONE,
                                padTop: 6, padBottom: 0, padLeft: 0, padRight: 0)
    bar.backColor = Theme::BACKGROUND

    @status_label = FXLabel.new(bar, "Ready", opts: JUSTIFY_LEFT)
    @status_label.font = Theme.status_font(app)
    @status_label.textColor = Theme::STATUS_TEXT
    @status_label.backColor = Theme::BACKGROUND

    spacer = FXLabel.new(bar, "", opts: LAYOUT_FILL_X)
    spacer.backColor = Theme::BACKGROUND

    @state_badge = FXLabel.new(bar, "STOPPED")
    @state_badge.font      = Theme.label_font(app)
    @state_badge.textColor = Theme::TEXT_MUTED
    @state_badge.backColor = Theme::BACKGROUND
  end

  # One-line hint bar at the very bottom listing keyboard shortcuts
  def build_shortcuts_hint(parent, app)
    hint = FXLabel.new(parent,
                       "  Space · Play/Pause    ←/→ · Prev/Next    ↑/↓ · Volume    S · Stop",
                       opts: JUSTIFY_LEFT | LAYOUT_FILL_X)
    hint.font = Theme.label_font(app)
    hint.textColor = Theme::TEXT_MUTED
    hint.backColor = Theme::BACKGROUND
    hint.padTop = 2
  end


  # Events & timers

  def wire_events
    @player = Player.new

    # Grab keyboard focus so SEL_KEYPRESS fires
    connect(SEL_MAP) { setFocus }

    # Keyboard shortcuts 
    connect(SEL_KEYPRESS) do |_sender, _sel, event|
      case event.code
      when KEY_space
        toggle_play
      when KEY_s, KEY_S
        do_stop
      when KEY_Left
        do_prev
      when KEY_Right
        do_next
      when KEY_Up
        new_vol = [@controls.volume_slider.value + 5, 100].min
        @controls.volume_slider.value = new_vol
        @controls.volume_label.text = "#{new_vol}%"
        @player.set_volume(new_vol)
      when KEY_Down
        new_vol = [@controls.volume_slider.value - 5, 0].max
        @controls.volume_slider.value = new_vol
        @controls.volume_label.text = "#{new_vol}%"
        @player.set_volume(new_vol)
      end
    end

    # Song list selection 
    @song_list.connect(SEL_COMMAND) { update_track_display }

    #  Play / Pause button 
    @controls.play_btn.connect(SEL_COMMAND) { toggle_play }

    #  Stop button 
    @controls.stop_btn.connect(SEL_COMMAND) { do_stop }

    #  Previous 
    @controls.prev_btn.connect(SEL_COMMAND) { do_prev }

    # Next 
    @controls.next_btn.connect(SEL_COMMAND) { do_next }

    #  Volume slider 
    @controls.volume_slider.connect(SEL_CHANGED) do 
      level = @controls.volume_slider.value
      @controls.volume_label.text = "#{level}%"
      @player.set_volume(level)
    end

    # ── Cleanup on close 
    connect(SEL_CLOSE) do
      stop_timers
      @player.cleanup
      getApp.exit(0)
    end

    # Polling timer: auto-advance + redraw art 
    start_poll_timer
    start_art_timer
  end

  # Timer loops

  def start_poll_timer
    getApp.addTimeout(POLL_INTERVAL, method(:on_poll_timer))
  end

  def on_poll_timer(_sender, _sel, _data)
    if @player.track_ended?
      do_next(auto: true)
    end
    # re-arm
    getApp.addTimeout(POLL_INTERVAL, method(:on_poll_timer))
  end

  def start_art_timer
    getApp.addTimeout(ART_INTERVAL, method(:on_art_timer))
  end

  def on_art_timer(_sender, _sel, _data)
    if @art_spinning
      @rotation_angle = (@rotation_angle + 1.2) % 360.0
      @album_art.update
    end
    getApp.addTimeout(ART_INTERVAL, method(:on_art_timer))
  end

  def stop_timers
    # FOX timers can't be easily cancelled by reference in all versions;
    # setting flags so callbacks become no-ops is sufficient here.
    @art_spinning = false
  end

  # Playback actions — shared between buttons and keyboard

  def toggle_play
    track = @song_list.selected_track
    return unless track

    if @player.playing
      @player.stop
      @controls.play_btn.text = "▶  Play"
      @status_label.text = "Paused  ·  #{track[:title]}"
      @state_badge.text = "PAUSED"
      @state_badge.textColor = Theme::TEXT_SECONDARY
      set_art_spinning(false)
    else
      success = @player.play(track[:file])
      if success
        @controls.play_btn.text = "⏸  Pause"
        @status_label.text      = "Playing  #{track[:title]}  ·  #{track[:artist]}"
        @state_badge.text       = "PLAYING"
        @state_badge.textColor  = Theme::ACCENT
        set_art_spinning(true)
      else
        @status_label.text     = "⚠  File not found: #{track[:file]}"
        @state_badge.text      = "ERROR"
        @state_badge.textColor = Theme::BTN_STOP_TXT
        set_art_spinning(false)
      end
    end
  end

  def do_stop
    @player.stop
    @controls.play_btn.text = "▶  Play"
    @status_label.text = "Stopped"
    @state_badge.text = "STOPPED"
    @state_badge.textColor = Theme::TEXT_MUTED
    @controls.progress_slider.value  = 0
    set_art_spinning(false)
  end

  def do_prev
    next_idx = [(@song_list.currentItem - 1), 0].max
    @song_list.currentItem = next_idx
    update_track_display
    auto_play_current
  end

  # auto: true means the track ended naturally (no UI feedback change needed
  # beyond what auto_play_current already does).
  def do_next(auto: false)
    max = @song_list.count - 1
    if @song_list.currentItem >= max
      # End of queue — stop gracefully
      do_stop
      @status_label.text = "End of queue"
      return
    end
    next_idx = @song_list.currentItem + 1
    @song_list.currentItem = next_idx
    update_track_display
    auto_play_current
  end


  # Helpers
  def set_art_spinning(spinning)
    @art_spinning = spinning
    @album_art.update
  end

  def update_track_display
    track = @song_list.selected_track
    return unless track

    @track_label.text  = track[:title]
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
      set_art_spinning(true)
    else
      @status_label.text = "⚠  File not found: #{track[:file]}"
      @state_badge.text = "ERROR"
      @state_badge.textColor = Theme::BTN_STOP_TXT
      set_art_spinning(false)
    end
  end
end
