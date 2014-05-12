Shoes.app :title => 'Soda Pups', :height => 375, :width => 610 do
  flow do
    image 'pup.png'
    @img = image 'pup.png' do
      @img.path = 'surprised_dog.jpg'
    end
  end
end