module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html
  end
  
  def post_content(content)
    text = simple_format(content)
    url_regexp = /\b((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/?)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s\`!()\[\]{};:\'\".,<>?«»“”‘’]))/i
    urls = text.scan(url_regexp)
    urls.each do |u|
      if u[0] != nil
        text[u[0]] = "<a href=#{u[0]}>#{u[0]}</a>"
      end
    end
    text
  end
  
  def trustworthiness_in_precent
    if current_user
      (current_user.trustworthiness[0]*100).to_i.to_s + "%"
    else
      "0%"
    end
  end

end
