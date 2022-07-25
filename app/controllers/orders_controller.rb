class OrdersController < ApplicationController
  helper_method [:get_patrimony, :get_user, :order_updated_at, :order_creator]
  before_action :stuff_category
  autocomplete :stuff, :patrimony, full: true
  include ApplicationHelper

  def index
    @technicians = User.where("user_level == 0 AND username != 'admin'")

    s_patrimony = params[:s_patrimony]
    s_spot = params[:s_spot]
    s_category = params[:s_category]
    s_brand = params[:s_brand]
    s_status = params[:s_status]
    s_technician = params[:s_technician]
    search_params = [s_patrimony, s_spot, s_category, s_brand, s_status, s_technician]
    sp = params[:sp]

    if search_params.all?
      order_w_patrimony = Order.joins(:stuff).where("patrimony LIKE ? AND 
                                                     lower(spot) LIKE lower(?) AND 
                                                     lower(category) LIKE lower(?) AND 
                                                     lower(brand) LIKE lower(?) AND 
                                                     maintenance_technician LIKE ? AND 
                                                     lower(status) LIKE lower(?)", 
                                                     "%#{s_patrimony}%", 
                                                     "%#{s_spot}%", 
                                                     "%#{s_category}%", 
                                                     "%#{s_brand}%", 
                                                     "%#{s_technician}%", 
                                                     "%#{s_status}%")

      @orders = is_admin? ? order_w_patrimony 
                          : order_w_patrimony.where('school_id = ?', current_user.school.id)
    elsif sp
      order_no_patrimony = Order.joins(:stuff).where('patrimony = ""')

      @orders = is_admin? ? order_no_patrimony 
                          : order_no_patrimony.where('school_id = ?', current_user.school.id)
    else
      @orders = is_admin? ? Order.all : Order.where('school_id = ?', current_user.school.id)
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
    @order = Order.new(order_params)

    @schools = School.all.collect {|s| [ s.name, s.id ] }
    @schools = @schools.sort_by {|label,code| Iconv.iconv('ascii//ignore//translit', 'utf-8', label).to_s}

    patrimony = params[:order][:stuff_attributes][:patrimony]

    @order.user_id = @order.updated_by = current_user.id
    @order.school_id = current_user.school.id if !is_admin?

    if Stuff.where(patrimony: patrimony).exists? && !patrimony.blank?
      requester = params[:order][:requester]
      spot = params[:order][:spot]
      defect = params[:order][:defect]
      stuff_id = Stuff.find_by_patrimony(patrimony).id
      @order = Order.new(requester: requester, spot: spot, defect: defect, stuff_id: stuff_id, user_id: current_user.id, school_id: current_user.school.id, updated_by: current_user.id)
    end

    if @order.save
      flash[:success] = "Chamado aberto com sucesso!"
      redirect_to orders_path
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @technicians = User.where(user_level: 0).where.not(name: "Administrador")
  end

  def update
    @order = Order.find(params[:id])
    @technicians = User.where(user_level: 0).where.not(name: "Administrador")
    @order.updated_by = current_user.id
    
    if @order.update(order_params)
      flash[:success] = "Dados do chamado atualizados com sucesso!"
      redirect_to orders_path
    else
      render :edit
    end
  end

  def order_params
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