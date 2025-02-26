require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name, unique email, and password' do
    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with: 'user1@example.com'
    fill_in :user_password, with: 'loki123'
    fill_in :user_password_confirmation, with: 'loki123'
    click_button 'Create New User'

    expect(current_path).to eq(user_path(User.last.id))
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'cannot create a user without matching password and password_confirmation' do
    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with: 'user1@example.com'
    fill_in :user_password, with: 'loki123'
    fill_in :user_password_confirmation, with: 'loki321'
    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Password confirmation doesn't match Password")
  end 

  it 'does not create a user if email isnt unique' do 
    User.create(name: 'User One', email: 'notunique@example.com', password: 'loki123')

    visit register_path

    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    fill_in :user_password, with: 'loki123'
    fill_in :user_password_confirmation, with: 'loki123'
    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
  end
end
