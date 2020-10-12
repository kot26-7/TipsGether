require 'rails_helper'

RSpec.describe 'Devise::Sessions', type: :system do
  describe 'GET /users/signin' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    it 'check if contents are displayed correctly on new_user_session' do
      within('#submit-form') do
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Password'
        expect(page).to have_button 'ログイン'
        expect(page).to have_field 'Email'
        expect(page).to have_field 'Password'
        expect(page).to have_unchecked_field 'remember_me'
      end
    end

    it 'login succsessfully' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'ログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'ログインしました。'
      visit current_path
      expect(page).not_to have_content 'ログインしました。'
    end

    it 'login failed' do
      fill_in 'Email', with: ''
      fill_in 'Password', with: user.password
      click_button 'ログイン'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content '不正なEmailとパスワードです。'
      visit current_path
      expect(page).not_to have_content '不正なEmailとパスワードです。'
    end
  end
end
