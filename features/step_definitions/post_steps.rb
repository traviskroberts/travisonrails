Given /^I have posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Post.create!(:title => title, :content => 'Test post.', :date => Date.today)
  end
end

When /^I visit the detail page for post "([^\"]*)"$/ do |post_title|
  post = Post.find_by_title(post_title)
  visit edit_admin_post_path(:id => post.id)
end

Then /^I should see "([^\"]*)" in the "([^\"]*)" field$/ do |value, field|
  field_labeled(field).value.should =~ /#{value}/
end

When /^I visit the delete page for post "([^\"]*)"$/ do |post_title|
  post = Post.find_by_title(post_title)
  visit admin_post_path(:id => post.id), :delete
end