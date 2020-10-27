require 'rails_helper'

RSpec.describe 'Post', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  before do
    sign_in user
  end

  describe 'posts#index' do
    context 'posts dont exist' do
      it 'check if contents are displayed correctly on posts_path' do
        visit posts_path
        within('#indx-list') do
          expect(page).to have_content '表示できる投稿が現在ありません。'
        end
      end
    end

    context 'posts exist' do
      let!(:post) { create(:published_post) }
      let!(:unpublished_post) { create(:unpublished_post) }
      let!(:unpblsh_other_post) { create(:unpublished_other_post) }
      let!(:pblsh_other_post) { create(:published_other_post) }

      before do
        visit posts_path
      end

      it 'check if contents are displayed correctly on posts_path' do
        within('#indx-list') do
          expect(page).to have_content '投稿一覧'
          expect(page).to have_link post.title
          expect(page).to have_link pblsh_other_post.title
          expect(page).not_to have_link unpublished_post.title
          expect(page).not_to have_link unpblsh_other_post.title
          expect(page).to have_link "投稿者: #{post.user.username}"
          expect(page).to have_link "投稿者: #{pblsh_other_post.user.username}"
        end
      end

      it 'post.title を押してpost_pathに飛ぶ' do
        within('#indx-list') do
          click_link post.title
        end
        expect(current_path).to eq post_path(post)
      end

      it 'post.user.username を押してuser_pathに飛ぶ' do
        within('#indx-list') do
          click_link "投稿者: #{post.user.username}"
        end
        expect(current_path).to eq user_path(post.user)
      end
    end
  end

  describe 'posts#show' do
    let(:post) { create(:published_post) }
    let(:pblsh_other_post) { create(:published_other_post) }

    before do
      visit post_path(post)
    end

    it 'check if contents are displayed correctly on post_path' do
      within('#submit-form') do
        expect(page).to have_content post.title
        expect(page).to have_content post.content
        expect(page).to have_content display_datetime(post.updated_at)
        expect(page).to have_link "投稿者: #{post.user.username}"
        expect(page).to have_css '.edt-icon'
        expect(page).to have_css '.dlt-icon'
      end
    end

    it 'Edit icon を押してpost編集ページにいく' do
      find('.edt-icon').click
      expect(current_path).to eq edit_post_path(post)
    end

    it 'check if contents are displayed correctly on post_path of other user' do
      visit post_path(pblsh_other_post)
      within('#submit-form') do
        expect(page).not_to have_css '.edt-icon'
        expect(page).not_to have_css '.dlt-icon'
      end
    end

    it 'Delete product successfully', js: true do
      page.accept_confirm do
        find('.dlt-icon').click
      end
      expect(page).to have_content '投稿が削除されました。'
      expect(current_path).to eq user_path(user)
      visit current_path
      expect(page).not_to have_content '投稿が削除されました。'
    end
  end

  describe 'posts#new' do
    before do
      visit new_post_path
    end

    it 'check if contents are displayed correctly on new_post_path' do
      within('#submit-form') do
        expect(page).to have_content '新規投稿'
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '内容'
        expect(page).to have_field 'タイトル'
        expect(page).to have_field '内容'
        expect(page).to have_unchecked_field '公開する'
        expect(page).to have_button '投稿する'
      end
    end

    it 'post create succsessfully' do
      within('#submit-form') do
        fill_in 'タイトル', with: 'sample test'
        fill_in '内容', with: 'sample content'
        check '公開する'
        click_button '投稿する'
      end
      expect(current_path).to eq post_path(1)
      expect(page).to have_content '投稿しました。'
      within('#submit-form') do
        expect(page).to have_content 'sample test'
        expect(page).to have_content 'sample content'
        expect(page).to have_link "投稿者: #{user.username}"
      end
      visit current_path
      expect(page).not_to have_content '投稿しました。'
    end

    it 'post create failed' do
      within('#submit-form') do
        click_button '投稿する'
      end
      expect(page).to have_content 'can\'t be blank'
    end
  end

  describe 'posts#edit' do
    let(:post) { create(:published_post) }

    before do
      visit edit_post_path(post)
    end

    it 'check if contents are displayed correctly on edit_post_path' do
      within('#submit-form') do
        expect(page).to have_content '投稿を編集する'
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '内容'
        expect(page).to have_field 'タイトル', with: post.title
        expect(page).to have_field '内容', with: post.content
        expect(page).to have_checked_field '公開する'
        expect(page).to have_button '投稿を更新する'
      end
    end

    it 'post update succsessfully' do
      within('#submit-form') do
        fill_in 'タイトル', with: 'sample title updated'
        fill_in '内容', with: 'sample content updated'
        uncheck '公開する'
        click_button '投稿を更新する'
      end
      expect(current_path).to eq post_path(post)
      expect(page).to have_content '投稿が更新されました。'
      within('#submit-form') do
        expect(page).to have_content 'sample title updated'
        expect(page).to have_content 'sample content updated'
        expect(page).to have_link "投稿者: #{user.username}"
      end
      visit current_path
      expect(page).not_to have_content '投稿が更新されました。'
    end

    it 'post update failed' do
      within('#submit-form') do
        fill_in 'タイトル', with: ''
        click_button '投稿を更新する'
      end
      expect(page).to have_content 'can\'t be blank'
    end
  end
end
