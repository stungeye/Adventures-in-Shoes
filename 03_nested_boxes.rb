    Shoes.app :width => 330, :height => 180 do
      flow :width => '100%', :margin => 10 do
        stack do
          title 'Nested Boxes'
        end
        stack :width => 150 do
          button 'One'
          button 'Two'
          button 'Buckle Shoe'
        end
        stack :width => -150 do
          button 'Three'
          button 'Four'
          button 'Knock Door'
        end
      end
    end