module ApplicationHelper
  def full_title(page_title = '')
    if page_title.present?
      "#{page_title} : #{Settings.base_title}"
    else
      Settings.base_title
    end
  end

  # datetime専用メソッド
  def display_datetime(datetime)
    if datetime.present?
      datetime.strftime('%Y/%m/%d %H:%M')
    else
      '2020/01/01 00:00'
    end
  end
end
