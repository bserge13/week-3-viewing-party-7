require 'rails_helper'

RSpec.describe "User Log In" do
  it 'has a link to login a user' do 
    visit root_path

    expect(page).to have_link('Log In')
    expect(page).to_not have_link('Log Out')
    expect(page).to_not have_content("Existing Users:")

    click_link('Log In')
    expect(current_path).to eq(login_path)
  end

  it 'can log in a user with valid credentialss' do 
    visit login_path

    expect(page).to have_content('Email:')
    expect(page).to have_content('Password:')
    expect(page).to have_button('Log In')

    user = User.create(name: 'Eric Bachmann', email: 'bachmanity_rocks@gmail.com', password: 'jingyangsux')

    fill_in :email, with: user.email 
    fill_in :password, with: user.password 
    
    click_button('Log In')
    expect(current_path).to eq(user_path(user))

    expect(page).to have_content("Welcome, #{user.name}")
  end

  it 'cannot log in with bad credentials' do
    user = User.create(name: 'Eric Bachmann', email: 'bachmanity_rocks@gmail.com', password: 'jingyangsux')
  
    visit login_path
  
    fill_in :email, with: user.email 
    fill_in :password, with: 'jinyangrox' 
  
    click_on 'Log In'
  
    expect(current_path).to eq(login_path)
  
    expect(page).to have_content('Sorry, your credentials are bad.')
  end

  it 'logs a user out of their session' do 
    visit login_path
    user = User.create(name: 'Eric Bachmann', email: 'bachmanity_rocks@gmail.com', password: 'jingyangsux')

    fill_in :email, with: user.email 
    fill_in :password, with: user.password 
    
    click_button('Log In')
    expect(current_path).to eq(user_path(user))
    expect(page).to have_link('Log Out')
    
    click_link('Log Out')
    expect(current_path).to eq(root_path)

    expect(page).to have_link('Log In')
    expect(page).to_not have_link('Log Out')
    expect(page).to have_button('Create New User')
  end

  it 'shows only a list of existing users if signed in as a default user' do 
    user = User.create(name: 'Eric Bachmann', email: 'bachmanity_rocks@gmail.com', password: 'jingyangsux')
    visit login_path

    fill_in :email, with: user.email 
    fill_in :password, with: user.password 
    click_button('Log In')

    visit root_path

    expect(page).to_not have_link('Log In')
    expect(page).to have_link('Log Out')
    expect(page).to have_content("Existing Users:")
    expect(page).to_not have_link(user.email)
  end

  it 'shows links of existing users if signed in as an admin user' do 
    user = User.create(name: 'Eric Bachmann', email: 'bachmanity_rocks@gmail.com', password: 'jingyangsux', role: 1)
    visit login_path

    fill_in :email, with: user.email 
    fill_in :password, with: user.password 
    click_button('Log In')

    visit root_path

    expect(page).to_not have_link('Log In')
    expect(page).to have_link('Log Out')
    expect(page).to have_content("Existing Users:")
    expect(page).to have_link(user.email)
  end

  it 'will not route a user to their dashboard page unless signed in' do 
    user = User.create(name: 'Eric Bachmann', email: 'bachmanity_rocks@gmail.com', password: 'jingyangsux')

    visit root_path
    
    visit dashboard_path(user)
    expect(current_path).to eq(root_path)
    expect(page).to have_content('You must be logged in or registered to access your dashboard')
  end 
end
