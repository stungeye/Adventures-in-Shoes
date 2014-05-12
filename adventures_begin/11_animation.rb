Shoes.app do
  trails = [[0,0]] * 60
  
  animate(24) do 
    clear do
      trails.shift
      trails << self.mouse[1,2]
      
      trails.each_with_index do |(x, y), i|
        oval :left => x, :top => y, :radius => i, :center => true
      end
    end
  end
end