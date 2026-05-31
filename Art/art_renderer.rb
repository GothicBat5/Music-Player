# art_renderer.rb

require_relative 'theme'

class ArtRenderer
  RINGS = [
    { radius: 76, orbit: 4.0, phase:   0, speed: 1.20 },
    { radius: 58, orbit: 3.0, phase:  22, speed: 0.90 },
    { radius: 40, orbit: 2.0, phase:  45, speed: 0.65 },
    { radius: 22, orbit: 1.2, phase:  70, speed: 0.40 },
  ].freeze

  IDLE_DOT_COLOR = :border   # resolved against Theme at draw time
  PLAYING_DOT_COLOR = :accent

  attr_reader :spinning

  def initialize
    @angle = 0.0
    @spinning = false
  end

  # Called by the art timer, advances animation state by one tick.
  # Returns true if a visual update is needed (always true while spinning.

  def tick
    return false unless @spinning

    RINGS.each { |r| }   # state is global angle:: per-ring speed applied at draw time
    @angle = (@angle + 1.5) % 360.0
    true
  end

  def start_spin
    @spinning = true
  end

  def stop_spin
    @spinning = false
  end

  # Draw everything into dc.  Call from inside a SEL_PAINT handler.
  def render(dc, width, height)
    cx = width  / 2
    cy = height / 2

    # Background fill
    dc.foreground = Theme::ART_BG
    dc.fillRectangle(0, 0, width, height)

    # Rings:each one orbits at its own speed and phase offset
    RINGS.each do |ring|
      effective_angle = @angle * (ring[:speed] / 1.0) + ring[:phase]
      rad = effective_angle * Math::PI / 180.0
      ox = (Math.cos(rad) * ring[:orbit]).round
      oy = (Math.sin(rad) * ring[:orbit]).round
      r = ring[:radius]

      dc.foreground = Theme::ART_BORDER
      dc.drawArc(cx - r + ox, cy - r + oy, r * 2, r * 2, 0, 360 * 64)
    end

    # Centre dot
    dc.foreground = @spinning ? Theme::ACCENT : Theme::ART_BORDER
    dc.fillArc(cx - 6, cy - 6, 12, 12, 0, 360 * 64)

    # Subtle outer glow ring when spinning: drawn at low contrast
    if @spinning
      glow_r = 84
      dc.foreground = Theme::ACCENT_DIM
      dc.drawArc(cx - glow_r, cy - glow_r, glow_r * 2, glow_r * 2, 0, 360 * 64)
    end
  end
end
