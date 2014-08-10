# coding: utf-8
module CommonHelper

  def parse_bbcode(str)
    str = Sanitize.clean(str)
    str = str.bbcode_to_html.gsub(/\r\n|\n/, "<br>").gsub(/\[hr\]/, "<hr>")
    str = auto_link(str, :sanitize => false).html_safe
  end

  def error_messages(f = nil)
    if f.error_notification
      f.error_notification
    end
  end

  def b(str)
    content_tag :strong, str
  end

  def span_label(content, style = '')
    content_tag :span, content, :class => (style.blank? ? "label" : "label #{style}")
  end

  def badge(content, style = '')
    content_tag :span, content, :class => (style.blank? ? "badge" : "badge badge-#{style}")
  end

  def i_tag(html_class)
    content_tag :i, nil, :class => html_class
  end

  def title(page_title, options={})
    @page_title ||= Sanitize.clean(page_title.to_s)
    return page_title
  end

  def datestr(t)
    if Time.now.year == t.year
      return t('time.today') if Time.now.yday == t.yday
      return t('time.yesterday') if Time.now.yday - 1 == t.yday
    end
    
    #mon = t('date.month_names')[t.mon-1]
    #"#{t.day}&nbsp;#{mon}"
    t.strftime("%e of %B -").strip
  end

  def ftime(time, *args)
    return nil  unless time
    options = { :wyear => false, :no_time => false, :seconds => false }
    args.each{ |a| options[a] = true }
    date = datestr(time)
    date += " #{time.year}" if options[:with_year] or time.year != Time.now.year

    seconds = options[:seconds] ? ":%S" : ''
    options[:no_time] ? date.html_safe : time.strftime("#{date} #{t('time.at')} %H:%M#{seconds}")
  end

  
  def count_time(time_in_seconds, var = 1)
    ### TODO: ###
    ### передалть бы всё это
    ending = var == 1 ? "а" : "у"
    if time_in_seconds <= 0
     return "" 
    elsif time_in_seconds < 1.minute
      return "#{time_in_seconds} " + Russian.p(time_in_seconds, "секунд#{ending}", 'секунды', 'секунд', 'секунды')
    elsif time_in_seconds < 1.hour
     human_time = (time_in_seconds / 1.minute)
     return "#{human_time} " + Russian.p(human_time, "минут#{ending}", 'минуты', 'минут', 'минуты')
    elsif time_in_seconds < 1.day
     human_time = (time_in_seconds / 1.hour)
     minutes = (time_in_seconds % 1.hour) / 1.minute
     ending = minutes == 1 ? "а" : "у"
     return "#{human_time} #{Russian.p(human_time, 'час', 'часа', 'часов', 'часа')}, #{minutes} " + Russian.p(minutes, "минут#{ending}", 'минуты', 'минут', 'минуты')
    else
     human_time = (time_in_seconds / 1.day)
     return "#{human_time} #{Russian.p(human_time, 'день', 'дня', 'дней', 'дня')}"
    end
  end

  def plur(*args)
    "#{args[0]} #{Russian.p args[0], args[1], args[2], args[3]}"
  end


  def xeditable(object, field_text, options = {})
    model_param = options.fetch(:model, object.class.to_s.underscore)
    data_url = options.fetch(:url, polymorphic_path(object))
    source = options.fetch(:source, nil)
    value_output = options.fetch(:display, object[field_text])

    if can? :edit, Round
      content_tag(:a, 
                  value_output, 
                  class: 'editable round-editable label label-primary', 
                  href: '#', 
                  data: { type: options.fetch(:type, 'text'), 
                  name: field_text, 
                  model: model_param,
                  url: data_url, 
                  source: source,
                  value: (options[:value] || nil)})
    else
      value_output
    end
  end

  
end