Shoes.app :height => 150, :width => 250 do
  stack :margin => 10 do
    start = button "Start" do
      @time = Time.now
      @label.replace "Stop watch started at #{@time}"
    end
    stop = button "Stop" do
      @label.replace "Stopped, #{Time.now - @time} seconds elapsed."
    end
    @label = para "Press start to begin timing."
  end
end