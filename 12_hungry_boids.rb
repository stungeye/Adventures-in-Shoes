# Hungry Boids v0.6 - A Shoes Application
#
# Author       : Wally Glutton - http://stungeye.com
# Summary      : A hungry swarm indeed!
#
# Boid Algo    : http://www.vergenet.net/~conrad/boids/pseudocode.html
# Notes        : My home-rolled Vector class appears to be quicker than the matrix library Vectors.
#
# Required     : You must have Shoes installed to view the boids.
# Get Shoes    : http://github.com/shoes/shoes#readme
# Learn Shoes  : http://cloud.github.com/downloads/shoes/shoes/nks.pdf
#
# License      : This is free and unencumbered software released into the public domain.
#
# Change Log   :    v0.1 - The initial swarm.
#                   v0.2 - Replaced custom random method with (min..max).rand
#                        - Mouse clicks add food. Careful not to add too much.
# Magnus Adamsson   v0.3 - Seems Shoes 0.r646 can no longer draw a zero radius circle
# Wally  Glutton    v0.4 - No longer using a $app global to access Shoes methods within the Food and Boid classes.
#                        - Moved class definitions above Shoes.app block as this was causing a problem for OSX builds.
#                        - Decreased the Stay Visible Damper by 50.
#                        - Fixed some spelling errors.
#                        - Assigned explicit app title, height & width.
# Wally Glutton     v0.5 - In Shoes Raisins an oval :radius now acutally defines its radius, and not the diameter like in early versions of Shoes.
#                        - Changed all references to RADIUS to DIAMETER and draw oval using :width.
#                   v0.6 - Changed license from CC Attribution to Public Domain.

srand
NUM_BOIDS = 40
NUM_FOODSTUFF = 5
boids = []
foodstuff = []

class Food
    DIAMETER = 30
    attr_reader :position
    def initialize (app, x=(rand*app.width), y=(rand*app.height))
        spawn x, y
        @app = app
    end
    def spawn (x=(rand*@app.width), y=(rand*@app.height))
        @size = DIAMETER
        @position = VectorK.new x, y
    end
    def eaten? boid
        if @position.nearby? DIAMETER, boid.position
            @size -= 1
        end
        if @size <= 0
            spawn
        end
    end
    def draw
        @app.fill rgb(0xFF, 0x30, 0xFF, 0.4)
        @app.oval :left => @position.x, :top => @position.y, :width => @size, :center => true
    end
end

class Boid
    DIAMETER = 20
    MAX_SPEED = 25
    AVOID_DIAMETER = DIAMETER*3 # Avoid other boids within this radius
    AVOID_DAMPER = 40
    ATTRACTION_DIAMETER = DIAMETER*8 # Gravitate to the centre of mass of boids within this radius
    ATTRACTION_DAMPER = 30
    ALIGNMENT_DIAMETER = DIAMETER*3 # Align velocity with boids within this radius
    ALIGNMENT_DAMPER =  50
    HUNTING_DIAMETER = DIAMETER*5 # Locate food within this radius
    HUNTING_DAMPER = 10
    STAY_VISIBLE_DAMPER = 400
    
    attr_reader :velocity, :position
    
    def initialize x, y, vx, vy, app
        @velocity = VectorK.new vx, vy 
        @position = VectorK.new x, y
        @velocity_delta = VectorK.new 0, 0
        @app = app
    end
    def calculate_avoidance_delta boids
        boids.each do |other|
            if @position.nearby? AVOID_DIAMETER, other.position
                @velocity_delta += (@position - other.position) / AVOID_DAMPER
            end
        end
    end
    def calculate_attraction_delta boids
        average_position = VectorK.new 0, 0
        visible_boids = 0
        boids.each do |other|
            if @position.nearby? ATTRACTION_DIAMETER, other.position
                average_position += other.position
                visible_boids += 1
            end
        end
        average_position /= visible_boids
        @velocity_delta +=  (average_position - @position) / ATTRACTION_DAMPER
    end
    def calculate_alignment_delta boids
        alignment_delta = VectorK.new 0, 0
        visible_boids = 0
        boids.each do |other|
            if @position.nearby? ALIGNMENT_DIAMETER, other.position
                alignment_delta += other.velocity
                visible_boids += 1
            end
        end
        alignment_delta /= visible_boids
        @velocity_delta += alignment_delta / ALIGNMENT_DAMPER
    end
    def calculate_hunting_delta foodstuff
        foodstuff.each do |food|
            if @position.nearby? HUNTING_DIAMETER, food.position
               @velocity_delta += (food.position - @position) / HUNTING_DAMPER
            end
        end
    end
    def calculate_stay_visible_delta
        mid_x = @app.width / 2
        mid_y = @app.height / 2
        @velocity_delta -= (@position - VectorK.new(mid_x, mid_y)) / STAY_VISIBLE_DAMPER
    end
    def apply_deltas
        @velocity += @velocity_delta
        @velocity_delta = VectorK.new 0, 0
    end
    def limit_speed
        if @velocity.r > MAX_SPEED
            @velocity /= @velocity.r # Create a unit vector
            @velocity *= MAX_SPEED   # Scale to max speed
        end
    end
    def move
        @position += @velocity
    end
    def draw
        @app.fill rgb(0x30, 0xFF, 0xFF, 0.5)
        @app.oval :left => @position.x, :top => @position.y, :width => DIAMETER, :center => true
        @app.line @position.x, @position.y, (@position.x + @velocity.x), (@position.y + @velocity.y)
    end
end

class VectorK
    attr_reader :x, :y
    def initialize x, y
        @x = x
        @y = y
    end
    def nearby? threshold, a
        return false if a === self
        (distance a) < threshold
    end
    def distance a
        Math.sqrt((@x - a.x)**2 + (@y - a.y)**2)
    end
    def / a
        if (a != 0)
            VectorK.new(@x / a, @y / a)
        else
            self
        end
    end
    def + a
        VectorK.new(@x + a.x, @y + a.y)
    end
    def - a
        VectorK.new(@x - a.x, @y - a.y)
    end
    def * a
        VectorK.new(@x * a, @y * a)
    end
    def r
        Math.sqrt(@x * @x + @y * @y)
    end
end

Shoes.app(:title => "Hungry Boids v0.6", :height => 600, :width => 800) do
    stroke rgb(0x30, 0x30, 0x05, 0.5)

    NUM_BOIDS.times { |i| boids[i] = Boid.new(rand * self.width, rand * self.height, (-15..15).rand, (-15..15).rand, self) }
    NUM_FOODSTUFF.times { |i| foodstuff[i] = Food.new(self) }

    click do |_,x,y|
        foodstuff.push Food.new(self, x, y)
    end

    animate(24) do
        clear do
            background rgb(0xFF, 0xFF, 0xFF)
            boids.each do |boid|
                boid.calculate_avoidance_delta boids   # Avoid other boids
                boid.calculate_attraction_delta boids  # Gravitate towards the centre-of-mass of nearby boids
                boid.calculate_alignment_delta boids   # Align velocity with nearby boids
                boid.calculate_hunting_delta foodstuff # Be on the lookout for food
                boid.calculate_stay_visible_delta      # Don't fly too far from home
                
                boid.apply_deltas
                boid.limit_speed
                
                boid.move
                boid.draw
                
                foodstuff.each do |food|
                    food.eaten? boid
                end
            end
            foodstuff.each do |food|
                food.draw
            end
        end
    end
end

