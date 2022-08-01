class OrdersController < ApplicationController
  helper_method [:get_patrimony, :get_user, :order_updated_at, :order_creator]
  before_action :stuff_category
  autocomplete :stuff, :patrimony, full: true
  include ApplicationHelper

  def index
    @technicians = User.where("user_level == 0 AND username != 'admin'")

    patrimony = params[:patrimony]
    spot = params[:spot]
    category = params[:category]
    brand = params[:brand]
    status = params[:status]
    technician = params[:technician]
    start_date = params[:start_date].blank? ? params[:end_date] : params[:start_date]
    end_date = params[:end_date].blank? ? params[:start_date] : params[:end_date]
    search = [patrimony, spot, category, brand, status, technician, start_date, end_date]

    if !search.all?(&:blank?)
      patrimony = patrimony.downcase == "s/p" ? "" : "%#{patrimony}%"

      query = "stuffs.patrimony LIKE ? AND lower(orders.spot) LIKE lower(?) AND lower(stuffs.category) LIKE lower(?) AND lower(stuffs.brand) LIKE lower(?) AND orders.maintenance_technician LIKE ? AND lower(orders.status) LIKE lower(?)"

      values = [patrimony, "%#{spot}%", "%#{category}%", "%#{brand}%", "%#{technician}%", "%#{status}%"]

      if !start_date.blank? || !end_date.blank?
        query += " AND date(orders.created_at) BETWEEN ? AND ?"
        values += [start_date.to_date, end_date.to_date]
      end

      @orders = Order.joins(:stuff).where(query, *values)

      @orders = is_admin? ? @orders 
                          : @orders.where('orders.school_id = ?', current_user.school.id)
      

      if (start_date && end_date) && (start_date > end_date)
        flash.now[:warning] = "A data inicial deve ser menor do que a final"
      end
    else
      @orders = is_admin? ? Order.all : Order.where('orders.school_id = ?', current_user.school.id)
    end
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
    spot = params[:order][:spot]
    defect = params[:order][:defect]
      
    if Stuff.where(patrimony: @patrimony).exists? && !@patrimony.blank?
      stuff_id = Stuff.find_by_patrimony(@patrimony).id

      @order = Order.new(requester: requester, spot: spot, defect: defect, stuff_id: stuff_id, user_id: current_user.id, school_id: school_id, updated_by: current_user.id)

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
      flash[:success] = "Chamado aberto com sucesso!"
      redirect_to orders_path
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @patrimony = @order.stuff.patrimony
    @technicians = User.where(user_level: 0).where.not(name: "Administrador")
  end

  def update
    allow_update = true

    @order = Order.find(params[:id])
    @technicians = User.where(user_level: 0).where.not(name: "Administrador")
    @patrimony = params[:order][:stuff_attributes][:patrimony] || ""
    school_id = params[:order][:school_id]

    unless @patrimony.blank?
      if school_id != Stuff.find_by_patrimony(@patrimony).school_id.to_s && !school_id.blank?
        allow_update = false
        flash.now[:alert] = "Patrimônio já pertence a outra unidade"
      end
    end
    
    if allow_update && @order.update(order_update_params)
      flash[:success] = "Dados do chamado atualizados com sucesso!"
      redirect_to orders_path
    else
      render :edit
    end
  end

  def order_params
    params.require(:order).permit(:requester, :spot, :defect, :stuff_id, :user_id, :school_id, :updated_by, stuff_attributes: [:patrimony, :brand, :category, :school_id])
  end

  def order_update_params
    params.require(:order).permit!
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])

    if @order.destroy
      flash[:alert] = "Chamado excluído com sucesso!"
      redirect_to orders_path
    end
  end

  def stuff_category
    @stuff_category = is_admin? ? "CATEGORIA DO EQUIPAMENTO" : "Selecione a categoria do equipamento"
    return @stuff_category
  end

  def get_patrimony(patrimony)
    patrimony.blank? ? "S/P" : patrimony
  end

  def get_user(id)
    user = User.find_by_id(id)
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