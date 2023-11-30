module ApplicationHelper
	def body_info
    info = "id=#{controller_name} class=#{action_name}"
  end

  def flash_message
    messages = ""
    [:success, :notice, :info, :warning, :error, :alert].each {|type|
      case type
        when :warning, :alert
          message_type = "Atenção!"
        when :notice, :info
          message_type = "Info!"
        when :success
          message_type = "Muito bem!"
        else
          message_type = ""
      end

      if flash[type]
        messages += "<div class=\"flash #{type}\"><button class=\"flash-close\"></button><p class=\"flash-title\">#{message_type}</p><p class=\"flash-body\">#{flash[type]}</p></div>"
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
    return is_admin?(current_user) ? current_user.first_name : current_user.school.usual_name
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
    types = ['Manutenção corretiva', 'Manutenção preventiva', 'Atendimento externo', 'Infraestrutura de redes', 
              'Sistemas', 'Administrativo', 'Acesso remoto', 'Entrega/doação de equipamento']
    return types
  end

  def list_categories
    categories = ['PC/Notebook', 'Monitor', 'Impressora', 'Rede', 'Estabilizador/No-Break', 'Outro']
    return categories
  end

  def list_brands
    brands = ['Genérico', 'Asus', 'Acer', 'AOC', 'APC', 'Apple', 'BenQ',  'Brother', 
              'CCE', 'Cisco', 'Daruma', 'Dell', 'D-Link', 'EPCOM', 'Epson', 'HP', 'IBM', 'Intelbras', 
              'Lenovo', 'Lexmark', 'LG', 'Microsoft', 'Multilaser', 'Neologic',
              'MyMax', 'Oro', 'PC Mix', 'Philips', 'Philco', 'Positivo', 
              'Qbex', 'Samsung', 'SMS', 'Sony', 'Toshiba', 'TP-Link']
    return brands
  end

  def list_spots
    spots = ['Administrativo', 'Biblioteca', 'Coordenação', 'Direção', 'Laboratório', 'Professores', 'Recurso', 'Secretaria', 'Vice-direção', 'Outro']
    return spots
  end

  def list_status
    status = ['Em aberto', 'Em manutenção', 'Para retirada', 'Garantia', 'Concluído', 'Para doação', 'Aguardando peça(s)', 'Aguardando descarte', 
              'Descarte', 'Cancelado']
    return status
  end

  def get_status(status)
    return I18n.transliterate(status).gsub(/\s+/, '-').delete('()').downcase
  end

  def order_creator(id)
    user = User.find_by_id(id)

    return is_school?(user) ? user.school.usual_name : user.first_name
  end

  def registered_data(data)
    limit = params[:limit].to_i > data ? data : params[:limit]
    content = params[:limit].blank? ? "(Total: #{data})" : "(exibindo #{limit} de #{data})"

    return content
  end
end