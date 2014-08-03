# Ported from http://processing.org/learning/topics/multipleparticlesystems.html

# Click the mouse to generate a burst of particles at mouse location.

# Each burst is one instance of a particle system with Particles and
# CrazyParticles (a subclass of Particle).

require 'forwardable'
load_library :vecmath

module Runnable
  def run
    self.reject! { |item| item.dead? }
    self.each { |item| item.run }
  end
end

class ParticleSystem 
  extend Forwardable
  def_delegators(:@particle_systems, :each, :<<, :reject!, :empty?)
  include Enumerable
  include Runnable    
  
  attr_reader :particle_systems 
  
  def initialize(number, origin)
    @particle_systems = [] 
    @origin = origin
    kind = rand < 0.5 ? Sketch::Particle : Sketch::CrazyParticle
    number.times { self << kind.new(origin) }
  end
  
  def dead?
    self.empty?
  end  
end


def setup
  size 640, 580   
  color_mode(RGB, 255, 255, 255, 100)
  ellipse_mode(CENTER)    
  origin = rand(5 .. 16)
  start_pos = Vec2D.new(width / 2, height / 2)
  @particle_systems = ParticleSystem.new(origin, start_pos)
end

def draw
  background 0
  @particle_systems.run
end

def mouse_pressed
  origin = rand(5 .. 16)
  vector = Vec2D.new(mouse_x, mouse_y)
  @particle_systems << ParticleSystem.new(origin, vector)
end


class Particle
  attr_reader :velocity, :origin, :lifespan, :radius, :acceleration
  def initialize(origin)
    @origin = origin
    @velocity = Vec2D.new(rand(-1.0 .. 1), rand(-2.0 .. 0))
    @acceleration = Vec2D.new(0, 0.05)
    @radius = 10
    @lifespan = 100
  end
  
  def run
    update
    grow
    render
    render_velocity_vector
  end
  
  def update
    @velocity += acceleration
    @origin += velocity
  end
  
  def grow
    @lifespan -= 1
  end
  
  def dead?
    lifespan <= 0
  end
  
  def render
    stroke(255, lifespan)
    fill(100, lifespan)
    ellipse(origin.x, origin.y, radius, radius)
  end
  
  def render_velocity_vector
    scale = 10
    arrow_size = 4
    push_matrix
    translate(origin.x, origin.y)
    rotate(velocity.heading)
    length = velocity.mag * scale
    line 0, 0, length, 0
    line length, 0, length - arrow_size, arrow_size / 2
    line length, 0, length - arrow_size, -arrow_size / 2
    pop_matrix
  end
end


class CrazyParticle < Particle
  def initialize(origin)
    super
    @theta = 0
  end
  
  def run
    update
    grow
    render
    render_rotation_line
  end
  
  def update
    super
    @theta += velocity.x * velocity.mag / 10
  end
  
  def grow
    @lifespan -= 0.8
  end
  
  def render_rotation_line
    push_matrix
    translate(origin.x, origin.y)
    rotate(@theta)
    stroke(255, lifespan)
    line(0, 0, 25, 0)
    pop_matrix
  end
end
