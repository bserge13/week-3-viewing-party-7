require 'rails_helper'

RSpec.describe "User Log In" do
  it 'has a link to login a user' do 
    visit '/'

    expect(page).to have_link('Log In')

    click_link('Log In')
    expect(current_path).to eq('/login')
  end

  it 'can log in a user with valid credentialss' do 
    visit '/login'

    expect(page).to have_content('Email:')
    expect(page).to have_content('Password:')
    expect(page).to have_button('Log In')

    user = User.create(name: 'Eric Bachmann', email: 'bachmanity_rocks@gmail.com', password: 'jingyangsux')

    fill_in :email, with: user.email 
    fill_in :password, with: user.password 
    
    click_button('Log In')
    expect(current_path).to eq(root_path)

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
end
