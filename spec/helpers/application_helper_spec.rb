require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title helper method' do
    it { expect(full_title(nil)).to eq 'TipsGether' }
    it { expect(full_title('')).to eq 'TipsGether' }
    it { expect(full_title('Home')).to eq 'Home : TipsGether' }
  end

  describe '#display_datetime helper method' do
    it { expect(display_datetime(nil)).to eq '2020/01/01 00:00' }
    it { expect(display_datetime(DateTime.new(2021, 5, 25, 12, 30, 45))).to eq '2021/05/25 12:30' }
  end
end
