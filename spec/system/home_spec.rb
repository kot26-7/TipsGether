require 'rails_helper'

RSpec.describe 'Home', type: :system do
  describe 'GET home/index' do
    context 'if not signin' do
      before do
        visit root_path
      end

      it 'check if contents are displayed correctly on root' do
        expect(page).to have_title full_title('Home')
        within('#nav-nt-signin') do
          expect(page).to have_link 'TipsGether'
        end
        within('.intro') do
          expect(page).to have_content 'TipsGether にようこそ'
        end
        within('.startup') do
          expect(page).to have_content 'ログインはこちらから'
          expect(page).to have_button '新規登録'
          expect(page).to have_button 'ログイン'
          expect(page).to have_button 'ゲストログイン(閲覧用)'
          expect(page).not_to have_button 'ログアウト'
        end
      end

      it '新規登録 ボタンを押してユーザー登録ページに飛ぶ' do
        within('.startup') do
          click_button '新規登録'
        end
        expect(current_path).to eq new_user_registration_path
      end

      it 'ログイン ボタンを押してユーザーログインページに飛ぶ' do
        within('.startup') do
          click_button 'ログイン'
        end
        expect(current_path).to eq new_user_session_path
      end

      it 'ゲストログイン(閲覧用)を押してログインする', js: true do
        within('.startup') do
          page.accept_confirm do
            click_button 'ゲストログイン(閲覧用)'
          end
        end
        expect(page).to have_content 'ゲストユーザーとしてログインしました。'
        expect(current_path).to eq root_path
        visit current_path
        expect(page).not_to have_content 'ゲストユーザーとしてログインしました。'
      end
    end

    context 'if signin' do
      let!(:user) { create(:user) }
      let!(:other_user) { create(:other_user) }
      let!(:post1) { create(:published_other_post, title: 'hello') }
      let!(:post2) { create(:published_post, title: 'hi') }
      let!(:post3) { create(:unpublished_other_post, title: 'hisample') }

      before do
        sign_in user
        visit root_path
      end

      it 'check if contents are displayed correctly on root' do
        within('.navbar') do
          expect(page).to have_link 'ユーザー一覧'
          expect(page).to have_link 'プロフィール'
          expect(page).to have_link 'プロフィール編集'
          expect(page).to have_link 'ログアウト'
          expect(page).to have_field 'Search'
          expect(page).to have_button '検索'
          expect(page).to have_select(options: ['検索対象', 'ユーザー', '投稿'])
        end
      end

      it 'ユーザー一覧 を押してユーザー一覧ページに飛ぶ' do
        within('.navbar-nav') do
          click_link 'ユーザー一覧'
        end
        expect(current_path).to eq users_path
      end

      it 'プロフィール を押してプロフィールページに飛ぶ' do
        within('.navbar-nav') do
          click_link 'プロフィール'
        end
        expect(current_path).to eq user_path(user)
      end

      it 'プロフィール編集 を押してプロフィール編集ページに飛ぶ' do
        within('.navbar-nav') do
          click_link 'プロフィール編集'
        end
        expect(current_path).to eq edit_user_path(user)
      end

      it 'ログアウト を押してログアウトする', js: true do
        within('.navbar-nav') do
          page.accept_confirm do
            click_link 'ログアウト'
          end
        end
        expect(page).to have_content 'ログアウトしました。'
        expect(current_path).to eq root_path
        visit current_path
        expect(page).not_to have_content 'ログアウトしました。'
      end

      it 'そのまま検索ボタンをおす' do
        within('.navbar') do
          click_button '検索'
        end
        expect(page).to have_content '検索が一致しませんでした。再度お試しください。'
        expect(page).to have_content 'キーワードが設定されていません。再度検索を行ってください。'
        expect(current_path).to eq search_path
      end

      it '検索対象を選択したまま検索する' do
        within('.navbar') do
          fill_in 'Search', with: 'sample'
          click_button '検索'
        end
        expect(page).to have_content '検索対象が設定されていません。再度お試しください。'
        expect(current_path).to eq search_path
      end

      it 'ユーザーを選択し検索する' do
        within('.navbar') do
          find("option[value='2']").select_option
          fill_in 'Search', with: 'foo'
          click_button '検索'
        end
        expect(page).to have_content 'ユーザーの検索結果'
        expect(page).to have_content "ユーザー名: #{other_user.username}"
        expect(page).not_to have_content "ユーザー名: #{user.username}"
        expect(current_path).to eq search_path
      end

      it '投稿を選択し検索する' do
        within('.navbar') do
          find("option[value='3']").select_option
          fill_in 'Search', with: 'hi'
          click_button '検索'
        end
        expect(page).to have_content '投稿の検索結果'
        expect(page).to have_content "タイトル: #{post2.title}"
        expect(page).to have_content "投稿者: #{post2.user.username}"
        expect(page).not_to have_content "タイトル: #{post1.title}"
        expect(page).not_to have_content "投稿者: #{post1.user.username}"
        expect(page).not_to have_content "タイトル: #{post3.title}"
        expect(page).not_to have_content "投稿者: #{post3.user.username}"
        expect(current_path).to eq search_path
      end
    end
  end
end
