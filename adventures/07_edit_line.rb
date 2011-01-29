    Shoes.app :height => 250, :width => 200 do
      stack :margin => 10 do
        @edit = edit_line :width => '90%' do
          # Block triggered when content changes.
          @para.text = @edit.text
        end
        @para = para ''
        button 'what?' do
          alert 'I SAID: ' + @edit.text
        end
      end
    end