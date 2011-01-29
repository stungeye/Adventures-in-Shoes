Shoes.app do
   trails = [[0,0]] * 60
   
   stroke rgb(0x10, 0x50, 0x50, 0.7)
   fill rgb(0x30, 0xFF, 0xFF, 0.6)
   
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