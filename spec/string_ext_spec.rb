require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe String do
  
  it "should strip all blank lines in the end" do
    text = <<-TEXT
      some text 
      and more more more
      some other
      
      with blank lines in the middle
      and in the end
      
         
        
      
    TEXT

    expected = "      some text 
      and more more more
      some other
      
      with blank lines in the middle
      and in the end"
    
    text.strip_blank_lines_at_end.should == expected
  end
  
end