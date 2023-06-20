class OrdersController < ApplicationController
  helper_method [:get_patrimony, :get_user, :order_updated_at]
  before_action :stuff_category
  before_action :technicians, only: [:index, :new, :create, :edit, :update]
  before_action :schools, only: [:new, :create, :edit, :update]
  autocomplete :stuff, :patrimony, full: true
  autocomplete :school, :name, full: true
  layout "print", only: :print_order

  def index
    # params[:view] = "list" if params[:view].nil?
    id = params[:id]
    patrimony = params[:patrimony]
    spot = params[:spot]
    category = params[:category]
    brand = params[:brand]
    status = params[:status]
    technician = params[:technician].blank? ? "" : params[:technician]
    o_type = params[:o_type]
    start_date = params[:start_date].blank? ? params[:end_date] : params[:start_date]
    end_date = params[:end_date].blank? ? params[:start_date] : params[:end_date]
    school = I18n.transliterate(params[:name]) if params[:name]

    @search = [id, patrimony, spot, category, brand, status, technician, o_type, start_date, end_date, school]

    @orders = Order.joins(:stuff, :school)

    if !@search.all?(&:blank?)
      patrimony = patrimony.to_s.downcase == "s/p" ? "" 
                                              : "%#{patrimony}%"

      query = "stuffs.patrimony LIKE ? AND lower(orders.spot) LIKE lower(?) AND lower(stuffs.category) LIKE lower(?) AND 
               lower(stuffs.brand) LIKE lower(?) AND orders.maintenance_technicians LIKE ? AND 
               lower(orders.o_type) LIKE lower(?) AND lower(schools.name_ascii) LIKE lower(?)"

      values = [patrimony, "%#{spot}%", "%#{category}%", "%#{brand}%", 
                "%#{technician}%", "%#{o_type}%", "%#{school}%"]

      if !start_date.blank? || !end_date.blank?
        query += " AND date(orders.created_at) BETWEEN ? AND ?"
        values += [start_date.to_date, end_date.to_date]
      end

      if !id.blank?
        query += " AND orders.id = ?"
        values += [id]
      end

      if !status.blank?
        query += " AND lower(orders.status) = lower(?)"
        values += [status]
      end

      @orders = @orders.where(query, *values)

      @orders = @orders.where('orders.school_id = ?', current_user.school.id) if is_school?(current_user)

      if (start_date && end_date) && (start_date > end_date)
        flash.now[:warning] = "A data inicial deve ser menor do que a final"
      end
    else
      @orders = @orders.where('orders.school_id = ?', current_user.school.id) if is_school?(current_user)
    end

    @orders = @orders.in_order_of(:status, list_status).page(params[:page]).per(params[:limit])
  end

  def new
    require 'iconv'

    @order = Order.new
    @order.build_stuff
  end

  def create
    allow_save = true
    @r_technicians = params[:order][:removal_technicians]
    @m_technicians = params[:order][:maintenance_technicians]
    @patrimony = params[:order][:stuff_attributes][:patrimony] || ""
    category = params[:order][:stuff_attributes][:category]
    brand = params[:order][:stuff_attributes][:brand]
    school_id = params[:order][:school_id]
    requester = params[:order][:requester]
    o_type = params[:order][:o_type]
    spot = params[:order][:spot]
    defect = params[:order][:defect]
    backup = params[:order][:backup]
    performed_service = params[:order][:performed_service]
    obs = params[:order][:obs]
    removal_technicians = params[:order][:removal_technicians]
    maintenance_technicians = params[:order][:maintenance_technicians]
    start_date = params[:order][:start_date]
    end_date = params[:order][:end_date]
    status = params[:order][:status]
    stuff = Stuff.find_by_patrimony_and_category_and_brand_and_school_id(@patrimony, category, brand, school_id)
    order_values = {requester: requester, o_type: o_type, spot: spot, defect: defect, backup: backup, performed_service: performed_service,
                    obs: obs, removal_technicians: removal_technicians, maintenance_technicians: maintenance_technicians, start_date: start_date,
                    end_date: end_date, status: status, user_id: current_user.id, school_id: school_id, updated_by: current_user.id}
      
    if Stuff.where(patrimony: @patrimony).exists? && !@patrimony.blank?
      stuff_id = Stuff.find_by_patrimony(@patrimony).id

      @order = Order.new(order_values.merge({stuff_id: stuff_id}))

      if school_id != Stuff.find_by_patrimony(@patrimony).school_id.to_s && !school_id.blank?
        allow_save = false
        flash.now[:alert] = "Patrimônio já pertence a outra unidade"
      end
    elsif !stuff.nil?
      stuff_id = stuff.id

      @order = Order.new(order_values.merge({stuff_id: stuff_id}))
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
  end

  def update
    allow_update = true
    @order = Order.find(params[:id])
    @patrimony = params[:order][:stuff_attributes][:patrimony] || ""
    category = params[:order][:stuff_attributes][:category]
    brand = params[:order][:stuff_attributes][:brand]
    defaulted = params[:order][:stuff_attributes][:defaulted]
    school_id = params[:order][:school_id]
    start_date = params[:order][:start_date]
    end_date = params[:order][:end_date]
    stuff = Stuff.find_by_patrimony(@patrimony)
    stuff_school = stuff.school_id.to_s unless stuff.nil?

    unless @patrimony.blank?
      if school_id != stuff_school && !school_id.blank? && !stuff_school.blank?
        allow_update = false
        flash.now[:alert] = "Patrimônio já pertence a outra unidade"
      end
    end

    unless start_date.blank? || end_date.blank?
      if start_date > end_date
        allow_update = false
        flash.now[:alert] = "A data final deve ser maior do que a inicial"
      end
    end

    if (!start_date.blank? && start_date.to_datetime > Date.today) || (!end_date.blank? && end_date.to_datetime > Date.today)
      allow_update = false
      flash.now[:alert] = "As datas inicial/final devem ser menores que a data de hoje"
    end

    if allow_update
      school_has_stuff = School.find(school_id).stuffs.exists?(patrimony: @patrimony)

      if school_has_stuff
        @order.stuff_id = stuff.id

        @order.update(order_params.except(:stuff_attributes))
        stuff.update(category: category, brand: brand, defaulted: defaulted)
      elsif stuff.nil? 
        new_stuff = Stuff.new(category: category, patrimony: @patrimony, brand: brand, school_id: school_id, defaulted: defaulted)
        new_stuff.save
        @order.stuff_id = new_stuff.id

        @order.update(order_params.except(:stuff_attributes))
      else
        @order.update(order_params)
      end

      flash[:success] = "Dados da OS atualizados com sucesso!"
      redirect_to orders_path
    else
      render :edit
    end
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

  def order_params
    params.require(:order).permit!
  end

  def print_order
    @order = Order.find(params[:id])
    @stuff = Stuff.find(@order.stuff_id)

    @full_address = "#{@order.school.address}, #{@order.school.address_number} - #{@order.school.district} - CEP: #{@order.school.zip_code}" 
    @stuff_type = "#{@stuff.category} - #{@stuff.brand} (#{@order.spot})" 
  end

  def stuff_category
    @stuff_category = is_admin?(current_user) ? "CATEGORIA DO EQUIPAMENTO" : "Selecione a categoria do equipamento"
    return @stuff_category
  end

  def get_patrimony(patrimony)
    patrimony.presence || "S/P"
  end

  def get_user(id)
    user = User.find(id.reject { |x| x.empty? }).map { |u| u.first_name }.to_sentence
    return user
  end

  def order_updated_at(datetime, id)
    time = datetime.strftime("%H:%M")
    date = datetime.strftime("%d/%m/%Y")
    user = User.find_by_id(id)
    
    if is_school?(user)
      creator = School.find_by_user_id(id).usual_name
    else
      creator = user.first_name
    end

    return "Última alteração em <strong>#{date}</strong> às #{time} por <strong>#{creator}</strong>".html_safe
  end

  def technicians
    @technicians = User.where("is_technician = 'Sim'").order("name ASC").select(:name, :id).map { |t| [t.name.split.first.strip, t.id] }
  end

  def schools
    @schools = School.all.collect {|s| [ s.name, s.id ] }
    @schools = @schools.sort_by {|label,code| Iconv.iconv('ascii//ignore//translit', 'utf-8', label).to_s}
  end
end