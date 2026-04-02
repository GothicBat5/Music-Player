
class Player
  attr_reader :playing, :current_song, :volume

  def initialize
    @playing = false
    @current_song = nil
    @volume = 80   # 0-100
  end

  def play(song)
    @current_song = song
    @playing = true
    # TODO: start audio stream
    log "Playing: #{song}"
  end

  def stop
    @playing = false
    # TODO: stop audio stream
    log "Stopped"
  end

  def set_volume(level)
    @volume = level.clamp(0, 100)
    # TODO: apply to audio backend
    log "Volume: #{@volume}%"
  end

  private

  def log(msg)
    puts "[Player] #{msg}"
  end
end
