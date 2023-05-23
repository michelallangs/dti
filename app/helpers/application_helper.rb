module ApplicationHelper
	def body_info
    info = "id=#{controller_name} class=#{action_name}"
  end

  def flash_message
    messages = ""
    [:success, :notice, :info, :warning, :error, :alert].each {|type|
      case type
        when :warning, :alert
          message_type = ""
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

  def is_admin?(user)
    user.user_level == 0
  end

  def is_school?(user)
    user.user_level == 1
  end

  def username
    return is_admin?(current_user) ? current_user.name : current_user.school.name.split(/(?=\-)/).first.strip
  end

  def current?(link_path)
    if request.fullpath.include?(link_path) && link_path != '/'
      'active'
    end
  end

  def list_segments
    segments = ['Infantil', 'Fundamental', 'Integral', 'Profissionalizante', 'Especial', 'Rural', 'Administrativo']
    return segments
  end

  def list_types
    types = ['Manutenção corretiva', 'Manutenção preventiva', 'Infraestrutura de redes', 
                  'Sistemas', 'Administrativo', 'Acesso remoto', 'Entrega/doação de equipamento']
    return types
  end

  def list_categories
    categories = ['PC/Notebook', 'Monitor', 'Impressora', 'Rede', 'Estabilizador/No-Break', 'Outro']
    return categories
  end

  def list_brands
    brands = ['Genérico', 'Asus', 'Acer', 'AOC', 'APC', 'Apple', 'BenQ',  'Brother', 
              'CCE', 'Cisco', 'Dell', 'D-Link', 'EPCOM', 'Epson', 'HP', 'IBM', 'Intelbras', 
              'Lenovo', 'Lexmark', 'LG', 'Microsoft', 'Multilaser', 'Neologic',
              'MyMax', 'Oro', 'PC Mix', 'Philips', 'Philco', 'Positivo', 
              'Qbex', 'Samsung', 'SMS', 'Toshiba', 'TP-Link']
    return brands
  end

  def list_spots
    spots = ['Biblioteca', 'Coordenação', 'Direção', 'Laboratório', 'Recurso', 'Secretaria']
    return spots
  end

  def list_status
    status = ['Em aberto', 'Em manutenção', 'Para retirada', 
              'Saiu para entrega', 'Aguardando peça(s)', 'Aguardando doação', 
              'Concluído', 'Cancelado']
    return status
  end

  def get_status(status)
    return I18n.transliterate(status).gsub(/\s+/, '-').delete('()').downcase
  end

  def order_creator(id)
    user = User.find_by_id(id)
    if user.user_level == 1
      creator = user.school.name.split(/(?=\-)/).first
    else
      creator = user.name
    end
    return creator
  end
end