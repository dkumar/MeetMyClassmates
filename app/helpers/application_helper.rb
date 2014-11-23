module ApplicationHelper
  def flash_message(type, text, flash_now=false)
    if flash_now
      flash.now[type] ||= []
      flash.now[type] << text
    else
      flash[type] ||= []
      flash[type] << text
    end
  end
end
