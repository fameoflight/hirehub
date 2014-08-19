module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def nav_link(link_text, link_path)
    #class_name = active_tab("#{link_path}$") ? 'active' : ''
    class_name = ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def show_intro?
    return current_user.new_user?
  end

  def active_tab(path)
    return request.path.match(/^#{path}/)
  end

  def syntax_highlight(text, lang)
    if lang == 'csharp' || lang == 'scala'
      lang = 'java'
    end
    return CodeRay.scan(text, lang).div
  end

  def datetime_link(datetime_obj)
    datetime_obj = datetime_obj.utc

    base_url = "http://timeanddate.com/worldclock/fixedtime.html?"
    depedent_url = datetime_obj.strftime("day=%d&month=%m&year=%Y&hour=%H&min=%M&sec=%S")

    return base_url + depedent_url
  end
end
