Given /^I have the following code:$/ do |code|
  @code = code
end

Given /^lines from (\d+) to (\d+) are selected$/ do |start_line, end_line|
  @selected_lines = [start_line.to_i, end_line.to_i]
end

Given /^I want them to be in the method called '(.+)'$/ do |name|
  @method_name = name
end

When /^I call 'extract method'$/ do
  @code = Rfactor::Code.new(@code)
  @new_code = @code.extract_method :name => @method_name,
      :start => @selected_lines[0],
      :end => @selected_lines[1]
end

Then /^the code should be:$/ do |expected|
  @new_code.should == expected
end
