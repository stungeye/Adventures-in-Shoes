 Shoes.app do
   fill rgb(0, 0.6, 0.9, 0.05)
   stroke rgb(0, 0.6, 0.9, 0.5)
 
   30.times do
     star(rand(self.width), rand(self.width), (5..7).rand)
   end
 
   fill rgb(0.6, 0, 0.8, 0.1)
   stroke rgb(0.6, 0, 0.8, 0.9)
 
   35.times do
     arrow(rand(self.width), rand(self.width), (20..100).rand)
   end
 end