class OrdersController < ApplicationController
  helper_method [:get_patrimony, :get_user, :order_updated_at, :order_creator]
  before_action :stuff_category
  autocomplete :stuff, :patrimony, full: true
  layout "print", only: :print_order
  include ApplicationHelper

  def index
    @technicians = User.where("user_level = 0 AND username != 'admin'").order("name ASC")

    patrimony = params[:patrimony]
    spot = params[:spot]
    category = params[:category]
    brand = params[:brand]
    status = params[:status]
    technician = params[:technician].blank? ? "" : params[:technician]
    o_type = params[:o_type]
    start_date = params[:start_date].blank? ? params[:end_date] : params[:start_date]
    end_date = params[:end_date].blank? ? params[:start_date] : params[:end_date]
    requester = I18n.transliterate(params[:requester]) if params[:requester]
    school = I18n.transliterate(params[:school]) if params[:school]
    @search = [patrimony, spot, category, brand, status, technician, o_type, start_date, end_date, requester, school]

    @orders = Order.joins(:stuff, :school)

    if !@search.all?(&:blank?)
      patrimony = patrimony.downcase == "s/p" ? "" 
                                              : "%#{patrimony}%"

      query = "stuffs.patrimony LIKE ? AND lower(orders.spot) LIKE lower(?) AND lower(stuffs.category) LIKE lower(?) AND 
               lower(stuffs.brand) LIKE lower(?) AND lower(orders.status) LIKE lower(?) AND orders.maintenance_technicians LIKE ? AND 
               lower(orders.o_type) LIKE lower(?) AND lower(orders.requester_ascii) LIKE lower(?) AND lower(schools.name_ascii) LIKE lower(?)"

      values = [patrimony, "%#{spot}%", "%#{category}%", "%#{brand}%", "%#{status}%", "%#{technician}%", 
                "%#{o_type}%", "%#{requester}%", "%#{school}%"]

      if !start_date.blank? || !end_date.blank?
        query += " AND date(orders.created_at) BETWEEN ? AND ?"
        values += [start_date.to_date, end_date.to_date]
      end

      @orders = @orders.where(query, *values)

      @orders = @orders.where('orders.school_id = ?', current_user.school.id) if is_school?
      

      if (start_date && end_date) && (start_date > end_date)
        flash.now[:warning] = "A data inicial deve ser menor do que a final"
      end
    else
      @orders = @orders.where('orders.school_id = ?', current_user.school.id) if is_school?
    end

    @orders = @orders.order("id DESC").page params[:page]
  end

  def new
    require 'iconv'

    @order = Order.new
    @order.build_stuff
    @schools = School.all.collect {|s| [ s.name, s.id ] }
    @schools = @schools.sort_by {|label,code| Iconv.iconv('ascii//ignore//translit', 'utf-8', label).to_s}
  end

  def create
    allow_save = true

    @schools = School.all.collect {|s| [ s.name, s.id ] }
    @schools = @schools.sort_by {|label,code| Iconv.iconv('ascii//ignore//translit', 'utf-8', label).to_s}

    @patrimony = params[:order][:stuff_attributes][:patrimony] || ""
    school_id = params[:order][:school_id]
    requester = params[:order][:requester]
    o_type = params[:order][:o_type]
    spot = params[:order][:spot]
    defect = params[:order][:defect]
      
    if Stuff.where(patrimony: @patrimony).exists? && !@patrimony.blank?
      stuff_id = Stuff.find_by_patrimony(@patrimony).id

      @order = Order.new(requester: requester, o_type: o_type, spot: spot, defect: defect, stuff_id: stuff_id, user_id: current_user.id, school_id: school_id, updated_by: current_user.id)

      if school_id != Stuff.find_by_patrimony(@patrimony).school_id.to_s && !school_id.blank?
        allow_save = false
        flash.now[:alert] = "Patrimônio já pertence a outra unidade"
      end
    else
      @order = Order.new
      @order.build_stuff
      @order.update(order_params)
      @order.stuff.school_id = school_id unless school_id.blank?
    end
    

    if allow_save && @order.save
      flash[:success] = "OS aberta com sucesso!"
      redirect_to orders_path
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @patrimony = @order.stuff.patrimony
    @technicians = User.where(user_level: 0).where.not(name: "Administrador").order("name ASC")
  end

  def update
    allow_update = true

    @order = Order.find(params[:id])
    @technicians = User.where(user_level: 0).where.not(name: "Administrador").order("name ASC")
    @patrimony = params[:order][:stuff_attributes][:patrimony] || ""
    school_id = params[:order][:school_id]
    start_date = params[:order][:start_date]
    end_date = params[:order][:end_date]

    unless @patrimony.blank?
      if school_id != Stuff.find_by_patrimony(@patrimony).school_id.to_s && !school_id.blank?
        allow_update = false
        flash.now[:alert] = "Patrimônio já pertence a outra unidade"
      end
    end

    unless start_date.blank? || end_date.blank?
      if start_date > end_date
        allow_update = false
        flash.now[:alert] = "A data de entrega deve ser maior que a de retirada"
      end
    end

    if (!start_date.blank? && start_date.to_datetime > Date.today) || (!end_date.blank? && end_date.to_datetime > Date.today)
      allow_update = false
      flash.now[:alert] = "As datas de retirada/entregam devem ser menores que a data de hoje"
    end
    
    if allow_update && @order.update(order_update_params)
      flash[:success] = "Dados da OS atualizados com sucesso!"
      redirect_to orders_path
    else
      render :edit
    end
  end

  def order_params
    params.require(:order).permit(:requester, :o_type, :spot, :defect, :stuff_id, :user_id, :school_id, :updated_by, stuff_attributes: [:patrimony, :brand, :category, :school_id])
  end

  def order_update_params
    params.require(:order).permit!
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.update(status: "Cancelado")

    if @order
      flash[:alert] = "OS cancelada com sucesso!"
      redirect_to orders_path
    end
  end

  def print_order
    @order = Order.find(params[:id])
    @stuff = Stuff.find(@order.stuff_id)

    @full_address = "#{@order.school.address}, #{@order.school.address_number} - #{@order.school.district} - CEP: #{@order.school.zip_code}" 
    @stuff_type = "#{@stuff.category} - #{@stuff.brand} (#{@order.spot})" 
  end

  def stuff_category
    @stuff_category = is_admin? ? "CATEGORIA DO EQUIPAMENTO" : "Selecione a categoria do equipamento"
    return @stuff_category
  end

  def get_patrimony(patrimony)
    patrimony.presence || "S/P"
  end

  def get_user(id)
    user = User.find(id.reject { |x| x.empty? }).map { |u| u.name }.to_sentence
    return user
  end

  def order_updated_at(date, id)
    user = User.find_by_id(id)
    if user.user_level == 1
      creator = School.find_by_user_id(id).name.split(/(?=\-)/).first.strip
    else
      creator = user.name
    end

    return "Última alteração em <strong>#{@order.updated_at.strftime("%d/%m/%Y")}</strong> às #{@order.updated_at.strftime("%H:%M")} por <strong>#{creator}</strong>".html_safe
  end
end