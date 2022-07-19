class OrdersController < ApplicationController
  helper_method [:get_patrimony, :get_user, :order_updated_at, :order_creator]
  before_action :stuff_category
  include ApplicationHelper

  def index
    search = params[:search]
    sp = params[:sp]

    if search && !search.blank?
      @orders = is_admin? ? Order.joins(:stuff).where(stuffs: { patrimony: search}) 
                          : Order.joins(:stuff).where(stuffs: { patrimony: search}, 
                                                      orders: { order_school: current_user.id })
    elsif sp
      @orders = is_admin? ? Order.joins(:stuff).where(stuffs: { patrimony: ""}) 
                          : Order.joins(:stuff).where(stuffs: { patrimony: ""}, 
                                                      orders: { order_school: current_user.id })
    else
      @orders = is_admin? ? Order.all : Order.where(order_school: current_user.id)
    end
  end

  def new
    @order = Order.new
    @order.build_stuff
    @schools = School.all
  end

  def create
    @order = Order.new(order_params)
    @schools = School.all
    @order.user_id = @order.updated_by = current_user.id
    order_school = is_admin? ? School.find(params[:order][:order_school]).user_id : current_user.id
    @order.order_school = order_school
    patrimony = params[:order][:stuff_attributes][:patrimony]

    if Stuff.where(patrimony: patrimony).exists? && !patrimony.blank?
      requester = params[:order][:requester]
      spot = params[:order][:spot]
      defect = params[:order][:defect]
      stuff_id = Stuff.find_by_patrimony(patrimony).id
      @order = Order.new(requester: requester, spot: spot, defect: defect, 
                         stuff_id: stuff_id, user_id: current_user.id, 
                         updated_by: current_user.id, order_school: order_school)
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
      flash[:success] = "Dados do chamado atualizado com sucesso!"
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
      flash[:success] = "Chamado excluído com sucesso!"
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
    user = User.find_by_id(id).name
    return user
  end

  def order_updated_at(date, id)
    user = User.find_by_id(id)
    if user.user_level == 1
      creator = School.find_by_user_id(id).name.split(/(?=\-)/).first.strip
    else
      creator = user.name
    end

    return "Última alteração em #{@order.updated_at.strftime("%d/%m/%Y")} às #{@order.updated_at.strftime("%H:%M")} por #{creator}"
  end

  def order_creator(id)
    user = User.find_by_id(id)
    if user.user_level == 1
      creator = School.find_by_user_id(id).name.split(/(?=\-)/).first
    else
      creator = user.name
    end
    return creator
  end

  def add_order
    
  end
end