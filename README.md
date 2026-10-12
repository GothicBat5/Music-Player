# About stuff 
> Audio Player Software

## Audio decode
I used `FFplay` for the audio, this support fully and Ruby can detect once it gets in the `"System path"`
Just download the `FFplay` online and find a permanent folder for zip extraction. Later you will system path it

### Audio:
```ruby
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
```

```c
#ifdef CONFIG_SND_DYNAMIC_MINORS
static int snd_find_free_minor(int type, struct snd_card *card, int dev)
```

## Simple 
This is my Repo about my music player application. --
I choose Ruby as my main programming language for this since it's very easy to write and read.
Also Ruby needs some more recognition so this is its chance... at least.

### Need::Update()
- [x] FFplay
- []  Red Stone
- []  Art 

[FF Player](https://www.ffmpeg.org/)
