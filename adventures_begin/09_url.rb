class ImageViewer < Shoes
  url '/', :index
  url '/stone', :stone

  def index
    stack :margin => 20 do
      image 'sign.jpg', :click => '/stone'
      para link('Nothing is set in stone...', :click => '/stone')
    end
  end
  
  def stone
    stack :margin => 20 do
      image 'nothing.jpg', :click => '/'
      para link('If you hit this sign...', :click => '/')
    end
  end
end

Shoes.app :title => 'Navigating a Sea of URL', :height => 425, :width => 550
