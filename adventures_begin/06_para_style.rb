    Shoes.app :title => 'Styles with Para', :width => 350, :height => 200 do
      stack :margin => 10 do
        para 'Lorizzle ipsum dolizzle sizzle amizzle, dizzle sheezy elizzle.', :stroke => red
        @text = para 'Learn to Question. Question to Learn.'
        @text.stroke = blue
        @text.style(:font =>'Cambria 14px', :underline=>'single')
      end
    end