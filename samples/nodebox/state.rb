# Ported from http://nodebox.net/code/index.php/Graphics_State

require 'ruby-processing'

class State < Processing::App
  def setup
    frame_rate 30
    smooth
    fill 0
  end

  def draw
    background 255
    translate 225, 225

    ellipse 0, 0, 10, 10
    text_font(create_font('Helvetica', 22))
    text 'sun', 10, 0

    3.times do |i|
      push_matrix

      rotate frame_count / -180.0 * PI + i * PI / -1.5
      line 0, 0, 120, 0

      translate 120, 0
      ellipse 0, 0, 10, 10
      text 'planet', 10, 0

      rotate frame_count / -30.0 * PI 
      line 0, 0, 30, 0
      text 'moon', 32, 0

      pop_matrix
    end
  end
end

State.new :width => 450, :height => 450, :title => 'State'
