class OrdersController < ApplicationController
  include ApplicationHelper

  def index
    if !params[:search].blank?
      stuff = Stuff.find_by_patrimony(params[:search])

      if stuff
        if is_admin?
          @orders = Order.joins(:stuff).where(stuffs: { patrimony: params[:search]}, 
                                              orders: { status: "Aberto" })
        else 
          @orders = Order.joins(:stuff).where(stuffs: { patrimony: params[:search]}, 
                                              orders: { user_id: current_user.id,
                                                        status: "Aberto" })
        end
      end
    else
      if is_admin?
        @orders = Order.all
      else
        @orders = Order.where(user_id: current_user.id)
      end
    end
  end

  def new
    @order = Order.new
    @order.build_stuff
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = current_user.id

    patrimony = params[:order][:stuff_attributes][:patrimony]

    if Stuff.where(patrimony: patrimony).exists?
      requester = params[:order][:requester]
      spot = params[:order][:spot]
      defect = params[:order][:defect]
      stuff_id =  Stuff.find_by_patrimony(patrimony).id unless patrimony.blank?
      @order = Order.new(requester: requester, spot: spot, defect: defect, stuff_id: stuff_id, user_id: current_user.id)
    end

    if @order.save
      flash[:notice] = "Chamado aberto com sucesso!"
      redirect_to orders_path
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    
    if @order.update(order_params)
      flash[:notice] = "Dados do chamado atualizado com sucesso!"
      redirect_to orders_path
    else
      render :edit
    end
  end

  def order_params
    params.require(:order).permit(
      :requester,
      :spot,
      :defect,
      :user_id,
      :stuff_id,
      :backup,
      :status,
      stuff_attributes: [
        :patrimony, 
        :category, 
        :brand
      ]
    )
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

  def add_order
    
  end
end