class SchoolsController < ApplicationController
	autocomplete :school, :name, full: true
  add_breadcrumb "unidades".html_safe, :schools_path
  add_breadcrumb "cadastrar unidade".html_safe, :new_school_path, only: [:new, :create]
  add_breadcrumb "editar dados da unidade".html_safe, :edit_school_path, only: [:edit, :update]

	def index
		id = params[:id]
		school_name = I18n.transliterate(params[:name]) if params[:name]
		email = params[:email]
		district = params[:district]
		zip_code = params[:zip_code]
    segment = params[:segment]
    @search = [id, school_name, email, district, zip_code, segment]

    @schools = School.joins(:user)

    if !@search.all?(&:blank?)
    	query = "lower(schools.name_ascii) LIKE lower(?) AND 
    					 lower(users.username) LIKE lower(?) AND 
    					 lower(schools.district) LIKE lower(?) AND 
    					 lower(schools.zip_code) LIKE lower(?) AND 
               lower(schools.segment) LIKE lower(?)"

      values = ["%#{school_name}%", "%#{email}%", "%#{district}%", "%#{zip_code}%", "%#{segment}%"]

      @schools = @schools.where(query, *values)
    else
    	@schools = @schools.where("schools.user_id = ?", current_user.id) if is_school?(current_user)
    end

	 	@schools = @schools.order("#{params[:sort_by].nil? ? "id" : params[:sort_by]} ASC") 

    @schools_paginate = @schools.page(params[:page]).per(params[:limit])

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
	end

	def new
		@user = User.new
		@user.build_school
	end

	def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Unidade cadastrada com sucesso!"
      redirect_to schools_path
    else
      render :new
    end
  end

	def edit
		@user = School.find(params[:id]).user
	end

	def update
		@user = School.find(params[:id]).user
		
		if @user.update(user_params)
      flash[:success] = "Dados atualizados com sucesso!"
      redirect_to schools_path
    else
      render :edit
    end
	end

	def destroy
    @user = School.find(params[:id]).user

    if @user.destroy
      flash[:alert] = "Unidade excluída com sucesso!"
      redirect_to schools_path
    end
  end

  def show
    @school = School.find(params[:id])

    add_breadcrumb "#{@school.usual_name}".html_safe, :school_path
    @orders = @school.orders.page(params[:orders_page]).per(5)
    @stuffs = @school.stuffs.page(params[:stuffs_page]).per(5)

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def user_params
    params.require(:user).permit!
  end
end