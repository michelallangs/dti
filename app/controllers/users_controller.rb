class UsersController < ApplicationController
	autocomplete :user, :name, full: true
  add_breadcrumb "usuários".html_safe, :users_path
  add_breadcrumb "cadastrar usuário".html_safe, :new_user_path, only: [:new, :create]
  add_breadcrumb "editar dados do usuário".html_safe, :edit_user_path, only: [:edit, :update]
  add_breadcrumb "trocar senha".html_safe, :edit_user_password_path, only: [:edit_password, :update_password]

	def index
		id = params[:id]
		name = params[:name]
		email = params[:email]
		username = params[:username]
    @search = [id, name, email, username]

    @users = User.where(user_level: 0)

    if !@search.all?(&:blank?)
    	query = "lower(name) LIKE lower(?) AND 
    					 lower(email) LIKE lower(?) AND 
    					 lower(username) LIKE lower(?)"

      values = ["%#{name}%", "%#{email}%", "%#{username}%"]

      @users = @users.where(query, *values)
    end

	 	@users = @users.order("#{params[:sort_by].nil? ? "users.id" : params[:sort_by]} ASC") 

    @users_paginate = @users.page(params[:page]).per(params[:limit])

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

    if @user.save
      flash[:success] = "Usuário cadastrado com sucesso!"
      redirect_to users_path
    else
      render :new
    end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
    is_technician = params[:is_technician]
    is_technician == "Sim" ? 1 : 0
    @user.is_technician = is_technician
		
		if @user.update(user_params)
      flash[:success] = "Dados atualizados com sucesso!"
      redirect_to users_path
    else
      render :edit
    end
	end

	def edit_password
		@user = User.find(params[:id])
	end

	def update_password
		@user = User.find(params[:id])

    if @user.valid_password?(params[:current_password]) || is_admin?(current_user)
      if @user.update(user_params)
        flash[:success] = "Senha atualizada com sucesso!"

        if @user == current_user 
          redirect_to profile_path
        elsif is_school?(@user)
          redirect_to school_path(@user.school)
        else 
          redirect_to user_path(@user)
        end
      else
        render :edit_password
      end
    else
      flash.now[:alert] = "Senha atual incorreta."
      render :edit_password
    end
	end

	def destroy
    @user = User.find(params[:id])

    if @user.destroy
      orders = Order.where("maintenance_technicians LIKE ? OR 
                            removal_technicians LIKE ? OR 
                            updated_by LIKE ?", "%#{@user.id}%", "%#{@user.id}%", "%#{@user.id}%")

      orders.map { |order| 
        maintenance_technicians = order.maintenance_technicians.delete(@user.id.to_s)
        removal_technicians = order.removal_technicians.delete(@user.id.to_s)
        updated_by = order.update(updated_by: User.first.id)
        order.save!
      }

      flash[:alert] = "Usuário excluído com sucesso!"
      redirect_to users_path
    end
  end

  def show
    @user = User.find(params[:id])

    add_breadcrumb "#{@user.first_name}".html_safe, :user_path

    list = []
    Order.all.map { |o| list << o if o.maintenance_technicians.include? @user.id.to_s }
    @orders = Order.where(id: list.pluck(:id)).page(params[:page]).per(5)

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

	def user_params
		params.require(:user).permit!
	end
end