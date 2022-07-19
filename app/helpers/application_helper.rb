module ApplicationHelper
	def body_info
    info = "id=#{controller_name} class=#{action_name}"
  end

  def flash_message
    messages = ""
    [:success, :notice, :info, :warning, :error, :alert].each {|type|
      case type
        when :warning, :alert
          message_type = "Atenção:"
        when :notice, :info
          message_type = ""
        when :success
          message_type = ""
        else
          message_type = ""
      end

      if flash[type]
        messages += "<div class=\"flash #{type}\"><p class=\"flash-title\">#{message_type}</p><p class=\"flash-body\">#{flash[type]}</p></div>"
      end
    }

    messages.html_safe
  end

  def is_admin?
    current_user.user_level == 0
  end

  def is_school?
    current_user.user_level == 1
  end

  def username
    return is_admin? ? current_user.name : current_user.school.name.split(/(?=\-)/).first.strip
  end

  def current?(link_path)
    if request.fullpath.include?(link_path) && link_path != '/'
      'active'
    end
  end

  def list_categories
    categories = ['PC/Notebook', 'Monitor', 'Impressora', 'Estabilizador/No-Break', 'Outro']
    return categories
  end

  def list_brands
    brands = ['Asus', 'Acer', 'AOC', 'APC', 'BenQ',  'Brother', 
              'Cisco', 'Dell', 'D-Link', 'Epson', 'HP', 'Intelbras', 
              'Lenovo', 'Lexmark', 'LG', 'Microsoft', 'Multilaser', 'Neologic', 
              'Oro', 'Philips', 'Positivo', 'Samsung', 'SMS', 'Toshiba', 'TP-Link']
    return brands
  end

  def list_spots
    spots = ['Secretaria', 'Laboratório', 'Direção', 'Recurso', 'Coordenação', 'Biblioteca']
    return spots
  end

  def list_status
    status = ['Em aberto', 'Em manutenção', 'Para retirada', 
              'Saiu para entrega', 'Aguardando peça(s)', 'Concluído']
    return status
  end

  def get_status(status)
    return I18n.transliterate(status).gsub(/\s+/, '-').delete('()').downcase
  end
end