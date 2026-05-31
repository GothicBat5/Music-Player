# progress_tracker.rb
#
# Tracks playback progress independently of ffplay.
# Uses ffprobe to read total duration once per track, then a monotonic
# clock to compute elapsed time.  Thread-safe via a Mutex.
class ProgressTracker
  attr_reader :duration_s

  def initialize
    @mutex = Mutex.new
    @start_time = nil
    @duration_s = nil
    @paused_at = nil        # elapsed seconds at the moment of pause
    @running = false
  end

  def start(file_path)
    dur = probe_duration(file_path)
    @mutex.synchronize do
      @duration_s = dur
      @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      @paused_at = nil
      @running = true
    end
  end

  def stop
    @mutex.synchronize do
      @running = false
      @start_time = nil
      @paused_at = nil
      @duration_s = nil
    end
  end

  def pause
    @mutex.synchronize do
      return unless @running
      @paused_at = raw_elapsed
      @running = false
    end
  end

  def resume
    @mutex.synchronize do
      return if @running
      # Shift start >> time so elapsed picks up from where we paused
      if @paused_at && @start_time
        @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - @paused_at
        @paused_at  = nil
      end
      @running = true
    end
  end


  def running?
    @mutex.synchronize { @running }
  end


  def elapsed_s
    @mutex.synchronize do
      e = raw_elapsed
      @duration_s ? [e, @duration_s].min : e
    end
  end


  def progress_pct
    return 0.0 unless @duration_s && @duration_s > 0
    (elapsed_s / @duration_s * 100.0).clamp(0.0, 100.0)
  end


  def elapsed_str
    format_time(elapsed_s)
  end


  def remaining_str
    return "--:--" unless @duration_s
    remaining = [@duration_s - elapsed_s, 0].max
    format_time(remaining)
  end


  def duration_str
    @duration_s ? format_time(@duration_s) : "--:--"
  end

  private

  # helpers

  def raw_elapsed
    return @paused_at || 0.0 unless @start_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - @start_time
  end

  def format_time(seconds)
    total = seconds.to_i.abs
    m = total / 60
    s = total % 60
    format("%d:%02d", m, s)
  end

  # Run ffprobe to extract duration; returns Float or null !
  def probe_duration(file_path)
    return nil unless File.exist?(file_path)

    output = IO.popen(
      ["ffprobe", "-v", "error",
       "-show_entries", "format=duration",
       "-of", "default=noprint_wrappers=1:nokey=1",
       file_path],
      err: File::NULL,
      &:read
    ).strip

    duration = output.to_f
    duration > 0 ? duration : nil
  rescue => e
    warn "[ProgressTracker] ffprobe failed: #{e.message}"
    nil
  end
end
