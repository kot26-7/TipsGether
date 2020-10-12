require 'rails_helper'

RSpec.describe 'Devise::Registrations', type: :system do
  describe 'GET /users/signup' do
    before do
      visit new_user_registration_path
    end

    it 'check if contents are displayed correctly on new_user_registration' do
      within('#submit-form') do
        expect(page).to have_content 'Username'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Password'
        expect(page).to have_content 'Password confirmation'
        expect(page).to have_content '半角英数字のみ'
        expect(page).to have_content '6文字以上'
        expect(page).to have_button '新規登録'
        expect(page).to have_field 'Username'
        expect(page).to have_field 'Email'
        expect(page).to have_field 'Password'
        expect(page).to have_field 'Password confirmation'
        expect(page).to have_button 'ログインを行う'
      end
    end

    it 'signup succsessfully' do
      fill_in 'Username', with: 'hogehoge'
      fill_in 'Email', with: 'foobar@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button '新規登録'
      expect(current_path).to eq root_path
      expect(page).to have_content 'ユーザー登録が完了しました。'
      visit current_path
      expect(page).not_to have_content 'ユーザー登録が完了しました。'
    end

    it 'signup failed' do
      fill_in 'Username', with: ''
      fill_in 'Email', with: 'foobar@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button '新規登録'
      expect(page).to have_content 'can\'t be blank'
      expect(page).to have_content 'is invalid'
    end
  end
end
