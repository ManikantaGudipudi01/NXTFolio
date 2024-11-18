require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    # Split name into first and last name
    name = user['name'].split(".")
    first_name = name[0]
    last_name = name[1]
    fake_password = user['password']
    job = user['job']

    # Create a User record
    user_record = User.create!(
      email: "#{first_name}.#{last_name}@example.com",
      password: fake_password,
      password_confirmation: fake_password
    )

    # Set values from the user hash, with defaults if values are missing
    company = user['company'] || "TestInc"        # Default company if missing
    industry = user['industry'] || "Fashion"      # Default industry if missing
    country = user['country'] || "United States"  # Default country if missing
    city = user['city'] || "Unknown City"         # Default city if missing
    state = user['state'] || "Unknown State"      # Default state if missing
    highlights = user['highlights'] || "N/A"      # Default highlights if missing

    # Create associated GeneralInfo record
    GeneralInfo.create!(
      id: user['id'],
      first_name: first_name,
      last_name: last_name,
      user: user_record,  # Associate GeneralInfo with the created User
      company: company,
      industry: industry,
      job_name: job,
      highlights: highlights,
      country: country,
      city: city,
      state: state,
      emailaddr: "#{first_name}.#{last_name}@example.com"
    )
  end
end



When(/^I click the button with id "([^"]*)"$/) do |id|
  button = find_by_id(id)
  button.click
end



Given(/^the following galleries exist$/) do |table|
  image_path = File.join(Rails.root, 'app', 'assets', 'images', '1.jpg')
  image_file = Rack::Test::UploadedFile.new(image_path, 'image/jpeg')
  table.hashes.each do |gallery_info|
    Gallery.create!(gallery_title: gallery_info['title'],
      #id: '2',
      gallery_description: gallery_info['description'],
      gallery_totalRate: gallery_info['id'],
      GeneralInfo_id: gallery_info['id'],
      gallery_totalRate: gallery_info['total'],
      gallery_totalRator: gallery_info['num'],
      gallery_picture: [image_file])
  end
end

When("I upload an image") do
  attach_file('test_picture', File.absolute_path('app/assets/images/4.jpg'), make_visible: true)
end

When("I upload multiple images") do
  files = [
    File.absolute_path('app/assets/images/4.jpg'),
    File.absolute_path('app/assets/images/5.jpg'),
    File.absolute_path('app/assets/images/6.jpg'),
    File.absolute_path('app/assets/images/a1.png')
  ]

  attach_file('test_picture', files, make_visible: true, multiple: true)
end




Given(/^the following galleries for testing delete exist$/) do |table|
  image_path1 = File.join(Rails.root, 'app', 'assets', 'images', '1.jpg')
  image_file1 = Rack::Test::UploadedFile.new(image_path1, 'image/jpeg')

  image_path2 = File.join(Rails.root, 'app', 'assets', 'images', '2.jpg')
  image_file2 = Rack::Test::UploadedFile.new(image_path2, 'image/jpeg')

  image_path3 = File.join(Rails.root, 'app', 'assets', 'images', '3.jpg')
  image_file3 = Rack::Test::UploadedFile.new(image_path3, 'image/jpeg')

  table.hashes.each do |gallery_info|
    Gallery.create!(gallery_title: gallery_info['title'],
      #id: '1',
      gallery_description: gallery_info['description'],
      gallery_totalRate: gallery_info['id'],
      GeneralInfo_id: gallery_info['id'],
      gallery_totalRate: gallery_info['total'],
      gallery_totalRator: gallery_info['num'],
      gallery_picture: [image_file1, image_file2, image_file3])
  end
end









And(/^the following reviews exist for galleries$/) do |table|
  ids = [1,2,3,4]
  index = 0
  table.hashes.each do |review_info|
    numss = review_info['rating'].split(",")
    nums = []
    for x in numss
      nums.push(x.to_i)
    end


    @gallery = Gallery.find_by(gallery_totalRate: ids[index])
    r = Review.create!(rating: nums, gallery_id: 1, general_info_id: 1)
    @gallery.reviews = r
    index += 1
  end
end


#  Given(/the following galleries exist/) do |gallery_table|

  
#   gallery_table.hashes.each do |gall|

#     gallery_info = Gallery.new
#     gallery_info.gallery_title = gall['title']
#     gallery_info.gallery_description = gall['description']
    
#     gallery_info.gallery_picture = [nil]
#     gallery_info.GeneralInfo_id = 1

#     gallery_info.reviews = Review.find(gallery_id: 1)
#     gallery_info.save!
#   end


# end

# Given(/the following reviews exist/) do |table|
#   table.hashes.each do |review|
#     review_info = Review.new
#     nums = review['rating'].split(",")
#     for x in nums 
#       x = x.to_i
#     end
#     review_info.rating = nums
#     review_info.general_info_id = review['general_info_id']
#     review_info.gallery_id = review['gallery_id']

#     review_info.save!
#   end
# end



Given(/the following countries exist/) do |location_table|
  location_table.hashes.each do |location|
    c = Country.create!(name: location['country'], iso3: location['country'])
    s = c.states.create!(name: location['state'], state_code: location['state'])
    s.cities.create!(name: location['city'])
  end
end

# a handy debugging step you can use in your scenarios to invoke 'pry' mid-scenario and poke around
When /I debug/ do
  binding.pry
end

Then(/^I should be on (.+)$/) do |page_name|
  current_path = URI.parse(current_url).path
  expect(current_path).to eq(path_to(page_name))
end




Given(/^I am logged in$/) do
  visit 'login_info/login'
  fill_in "email", :with => @login_info.email
  fill_in "password", :with => @login_info.password
  click_button "Login"
end

Given(/^I am logged in as "(.+)"$/) do |user|
  # get user info
  name = user.split(".")
  email = "#{name[0]}.#{name[1]}@example.com"
  login_info = LoginInfo.find_by(email: email)

  # login as user
  visit 'login_info/login'
  fill_in "login_email", :with => login_info.email
  fill_in "login_password", :with => login_info.password
  click_button "SIGN IN"
end

Given(/^I am on (.+)$/) do |page_name|
  visit path_to(page_name)
end

Given(/^I am searching$/) do
  visit 'search_engine/show'
end

Then /^I am with id gallery (\d+)$/ do |id|
  visit gallery_path(id)
end


When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    fill_in(name, :with => value)
  end
end



Then /^(?:|I )should see the following fields:$/ do |fields|
  fields.rows_hash.each do |name, value|
    expect(find_field(name).value).to eq(value)
  end
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When('I click on submit') do
  find('#submit').click
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When(/^I move to Edit Profile and select Change Password$/) do 
  visit "/login_info/edit"
end

When(/^I click on "([^"]*)"$/) do |button|
  click_link_or_button(button)
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
  # puts(page.body)
  expect(page).to have_content(text)
end

Then(/^(?:|I )should land on the Change Password page$/) do
  # puts(page.body)
  expect(page).to have_content("Change Password")
end

# test sorting
Then(/^I should see "([^"]*)" to the left of "([^"]*)"$/) do |left, right|
  page_content = page.text
  expect(page_content).to match(/#{left}.*#{right}/m)
end



Then(/^(?:|I )should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_content(text)
end

# untested method
Then(/^(?:|I ) should see "([^"]*)" in the (.+) section$/) do |expected_text, section_selector|
  expect(page).to have_selector(section_selector, text: expected_text)
end

# untested method
When(/^I hover over the "([^"]*)" element$/) do |element|
  # find the element using Selenium WebDriver
  target_element = find(:xpath, "//*[@id='#{element}']")

  # use the Selenium WebDriver 'action' object to hover over the element
  page.driver.browser.action.move_to(target_element.native).perform
end


Given (/"(.+)" sends a message to "(.+)" saying "(.+)"/) do |from_user, to_user, msg|
  step "I am logged in as \"#{from_user}\""
  visit path_to "the DM page"
  step "I click on \"Search\""
  step "I fill in \"user_search\" with \"#{to_user.gsub('.', ' ')}\""
  step "I select \"#{to_user.gsub('.', ' ')}\" chat"
  fill_in("body", :with => msg)
  click_link_or_button "Send"
  click_link_or_button "Log out"
end
When("I click on the image with alt text {string}") do |alt_text|
  # Find the image element with the specified alt text
  image = find("img[alt='#{alt_text}']")

  # Click on the image element
  image.click

end

Given("I store the email {string} for later verification") do |email|
  @user_email = email
end

Then("I should receive a confirmation email with a link to confirm my account") do
  raise "Email not set" if @user_email.nil?
  open_email(@user_email)
  expect(current_email).to have_content("Confirm my account")
end

# Step to follow the confirmation link in the email
When("I follow the email confirmation link") do
  # Ensure the email is opened
  raise "No email found" unless current_email

  # Extract the confirmation link from the email
  confirmation_link = current_email.body.match(/href="([^"]+)"/)[1]

  # Visit the confirmation link
  visit confirmation_link
end

  # todo! create a message
  # from_name = from_user.split(".")
  # from_email = "#{from_name[0]}.#{from_name[1]}@example.com"
  # from_info = GeneralInfo.find_by(email: from_email)

  # to_name = to_user.split(".")
  # to_email = "#{to_name[0]}.#{to_name[1]}@example.com"
  # to_info = GeneralInfo.find_by(email: to_email)



  # users = [from_user.id, to_user.id].sort
  # room_name = "private_#{users[0]}_#{users[1]}"
  # @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, @chatting_with], @room_name)

  # @message = Message.create(general_info_id: @user[:id], room_id: @single_room[:id], body: params[:body], chatting_with: @chatid)

#end
