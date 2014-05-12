require 'matrix'

DIRECTIONS = {
  left:  Vector[-1, 0],
  right: Vector[1,  0],
  up:    Vector[0, -1],
  down:  Vector[0,  1]
}

class Creature
  CREATURE_SIZE = 40
  
  def initialize x, y, app
    @app = app
    @position = Vector[x, y]
    @velocity = Vector[0, 0]
    @shape = @app.oval :left => x, :top => y, :width => CREATURE_SIZE, :center => true
  end
  
  def change_velocity direction
    @velocity += direction
  end
  
  def update_position
    @position += @velocity
  end
  
  def draw
    @shape.left = @position[0]
    @shape.top  = @position[1]
  end
end


Shoes.app(:title => "Simple", :height => 600, :width => 800) do
  my_creature = Creature.new self.width/2, self.height/2, self
  
  keypress do |key|
    my_creature.change_velocity DIRECTIONS[key]  if DIRECTIONS[key]
  end
  
  animate(24) do
    my_creature.update_position
    my_creature.draw
  end
end


