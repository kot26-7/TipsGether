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
          expect(page).not_to have_button 'ログアウト'
        end
      end
    end
  end
end
