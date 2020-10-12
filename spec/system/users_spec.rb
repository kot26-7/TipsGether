require 'rails_helper'

RSpec.describe 'User', type: :system do
  let(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  before do
    sign_in user
  end

  describe 'GET user#index' do
    before do
      visit users_path
    end

    it 'check if contents are displayed correctly on users_path' do
      within('#users-list') do
        expect(page).to have_content 'ユーザー一覧'
        expect(page).to have_content user.username
        expect(page).to have_content other_user.username
      end
    end

    it 'user.username を押して user ページに飛ぶ' do
      within('#users-list') do
        click_link user.username
      end
      expect(current_path).to eq user_path(user)
    end

    it 'other_user を押して other_user ページに飛ぶ' do
      within('#users-list') do
        click_link other_user.username
      end
      expect(current_path).to eq user_path(other_user)
    end
  end

  describe 'GET user#show' do
    it 'check if contents are displayed correctly on user_path' do
      visit user_path(user)
      within('#user-profile') do
        expect(page).to have_content user.username
        expect(page).to have_content user.email
      end
    end

    it 'check if contents are displayed correctly on another user_path' do
      visit user_path(other_user)
      within('#user-profile') do
        expect(page).to have_content other_user.username
        expect(page).not_to have_content other_user.email
      end
    end
  end

  describe 'GET user#edit' do
    before do
      visit edit_user_path(user)
    end

    it 'check if contents are displayed correctly on edit_user' do
      within('#submit-form') do
        expect(page).to have_content 'プロフィール編集'
        expect(page).to have_content 'Username'
        expect(page).to have_content 'Email'
        expect(page).to have_content '紹介文'
        expect(page).to have_button 'プロフィールを更新'
        expect(page).to have_field 'Username', with: user.username
        expect(page).to have_field 'Email', with: user.email
        expect(page).to have_field '紹介文'
        expect(page).to have_link 'パスワードを変更'
        expect(page).to have_link 'アカウントを削除'
      end
    end

    it 'パスワードを変更 を押してパスワード編集ページに飛ぶ' do
      click_link 'パスワードを変更'
      expect(current_path).to eq edit_user_registration_path
    end

    it 'update succsessfully' do
      fill_in 'Username', with: 'testhoge'
      fill_in '紹介文', with: 'this is sample'
      click_button 'プロフィールを更新'
      expect(current_path).to eq user_path(1)
      expect(page).to have_content 'ユーザー情報が更新されました。'
      within('#user-profile') do
        expect(page).to have_content user.introduce
      end
      visit current_path
      expect(page).not_to have_content 'ユーザー情報が更新されました。'
    end

    it 'update failed' do
      fill_in 'Username', with: ''
      click_button 'プロフィールを更新'
      expect(page).to have_content 'can\'t be blank'
      expect(page).to have_content 'is invalid'
    end

    # it 'Delete user successfully', js: true do
    #   page.accept_confirm do
    #     click_link 'アカウントを削除'
    #   end
    #   expect(current_path).to eq root_path
    #   expect(page).to have_content 'ユーザーアカウントが削除されました。'
    #   visit current_path
    #   expect(page).not_to have_content 'ユーザーアカウントが削除されました。'
    # end
  end

  describe 'GET /users/password_edit' do
    before do
      visit edit_user_registration_path
    end

    it 'check if contents are displayed correctly on edit_user_registration' do
      within('#submit-form') do
        expect(page).to have_content 'パスワード変更'
        expect(page).to have_content 'Password'
        expect(page).to have_content 'Password confirmation'
        expect(page).to have_content 'Current password'
        expect(page).to have_field 'Password'
        expect(page).to have_field 'Password confirmation'
        expect(page).to have_field 'Current password'
        expect(page).to have_button 'パスワードを更新'
        expect(page).to have_link '戻る'
      end
    end

    it 'password update succsessfully' do
      within('#submit-form') do
        fill_in 'Password', with: 'hogehoge'
        fill_in 'Password confirmation', with: 'hogehoge'
        fill_in 'Current password', with: 'password'
        click_button 'パスワードを更新'
      end
      expect(current_path).to eq root_path
      expect(page).to have_content 'パスワード情報が更新されました。'
      visit current_path
      expect(page).not_to have_content 'パスワード情報が更新されました。'
    end
  end
end
