When /^I create a new genomer project$/ do
  step 'I successfully run `genomer init project`'
  step 'I cd to "project"'
  step 'I append to "Gemfile" with "gem \'genomer-plugin-view\', :path =>\'../../../\'"'
end

Then /^the output should contain a valid man page$/ do
  step 'the output should not contain "md2man/roff: raw_html not implemented"'
  step 'the output should not contain "\<"'
  step 'the output should not contain "\>"'
end
