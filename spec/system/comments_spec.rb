require 'rails_helper'

RSpec.describe 'Comment', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:post) { create(:published_other_post) }

  describe 'Comment field' do
    before do
      sign_in user
    end

    context 'when Comment present' do
      let!(:comment) { create(:comment) }

      it 'check if contents are displayed correctly on comment field' do
        visit post_path(post)
        within('#submit-form') do
          expect(page).to have_content post.title
        end
        within('#comment-field') do
          expect(page).to have_content 'Comments'
          expect(page).to have_field 'コメント'
          expect(page).to have_button 'コメントする'
          expect(page).to have_content user.username
          expect(page).to have_content comment.content
        end
      end
    end

    context 'when no Comments' do
      before do
        visit post_path(post)
      end

      it 'check if contents are displayed correctly on comment field' do
        within('#submit-form') do
          expect(page).to have_content post.title
        end
        within('#comment-field') do
          expect(page).not_to have_content 'Comments'
          expect(page).to have_field 'コメント'
          expect(page).to have_button 'コメントする'
        end
      end

      it 'comment posted successfully', js: true do
        within('#comment-field') do
          fill_in 'コメント', with: 'this is sample comment hello'
          click_button 'コメントする'
        end
        expect(page).not_to have_content 'Comments'
        within('#comment-field') do
          expect(page).to have_content user.username
          expect(page).to have_content 'this is sample comment hello'
          expect(page).to have_field 'コメント', with: ''
        end
        expect(current_path).to eq post_path(post)
      end
    end
  end
end
