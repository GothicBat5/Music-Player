# player.rb

class Player
  attr_reader :playing, :current_song, :volume

  def initialize
    @playing = false
    @current_song = nil
    @volume = 80
    @process = nil
  end

  def play(file_path)
    stop  # kill any existing playback first

    unless File.exist?(file_path)
      warn "[Player] File not found: #{file_path}"
      return false
    end

    @current_song = file_path
    @playing  = true
    @track_ended_naturally = false

    @process = IO.popen(["ffplay", "-nodisp", "-autoexit", "-volume", @volume.to_s, file_path], err: File::NULL)

    log "Playing: #{file_path}"
    true
  end

  def stop
    return unless @process

    begin
      Process.kill("KILL", @process.pid)
      @process.close
    rescue Errno::ESRCH, Errno::EBADF
      # Process already ended naturally — fine
    ensure
      @process = nil
      @playing = false
      @current_song = nil
    end

    log "Stopped"
  end

  # Returns true once when the track finishes on its own (not from stop/skip).
  # Calling this consumes the signal — subsequent calls return false until the
  # next natural end.
  def track_ended?
    return false unless @process && @playing

    result = Process.waitpid2(@process.pid, Process::WNOHANG)
    return false unless result  # still running

    # Process exited on its own
    begin
      @process.close
    rescue IOError
    end
    @process = nil
    @playing = false
    @current_song = nil
    log "Track ended naturally"
    true
  rescue Errno::ECHILD
    # Already reaped
    @process = nil
    @playing = false
    @current_song = nil
    true
  end

  def set_volume(level)
    @volume = level.clamp(0, 100)
    log "Volume set to #{@volume}%"

    if @playing && @current_song
      song = @current_song
      stop
      play(song)
    end
  end

  def cleanup
    stop
  end

  private

  def log(msg)
    puts "[Player] #{msg}"
  end
end
