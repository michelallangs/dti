class StuffsController < ApplicationController
	autocomplete :stuff, :patrimony, full: true
  autocomplete :school, :name, full: true
  before_action :schools, only: [:new, :create, :edit, :update]
  add_breadcrumb "equipamentos".html_safe, :stuffs_path
  add_breadcrumb "cadastrar equipamento".html_safe, :new_stuff_path, only: [:new, :create]
  add_breadcrumb "editar dados do equipamento".html_safe, :edit_stuff_path, only: [:edit, :update]

	def index
		id = params[:id]
		patrimony = params[:patrimony]
    category = params[:category]
    brand = params[:brand]
    school_name = I18n.transliterate(params[:name]) if params[:name]
    @search = [id, patrimony, category, brand, school_name]

    @stuffs = Stuff.joins(:school)

    if !@search.all?(&:blank?)
    	patrimony = patrimony.downcase == "s/p" ? "" 
    																					: "%#{patrimony}%"

    	query = "stuffs.patrimony LIKE ? AND 
               lower(stuffs.category) LIKE lower(?) AND 
               lower(stuffs.brand) LIKE lower(?) AND 
               lower(schools.name_ascii) LIKE lower(?)"

      values = [patrimony, "%#{category}%", "%#{brand}%", "%#{school_name}%"]

      if !id.blank?
        query += " AND stuffs.id LIKE ?"
        values += [id]
      end

      @stuffs = @stuffs.where(query, *values)
    else
    	@stuffs = @stuffs.where("schools.user_id = ?", current_user.id) if is_school?(current_user)
    end


	 	@stuffs = @stuffs.order("#{params[:sort_by].nil? ? "stuffs.id" : params[:sort_by]} ASC") 

    @stuffs_paginate = @stuffs.page(params[:page]).per(params[:limit])

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
	end

  def new
    @stuff = Stuff.new
  end

  def create
    @stuff = Stuff.new(stuff_params)

    if @stuff.save
      flash[:success] = "Equipamento cadastrado com sucesso!"
      redirect_to stuffs_path
    else
      render :new
    end
  end

	def edit
		@stuff = Stuff.find(params[:id])
	end

	def update
		@stuff = Stuff.find(params[:id])
		
		if @stuff.update(stuff_params)
      flash[:success] = "Dados atualizados com sucesso!"
      redirect_to stuffs_path
    else
      render :edit
    end
	end

	def destroy
    @stuff = Stuff.find(params[:id])

    if @stuff.destroy
      flash[:alert] = "Equipamento excluído com sucesso!"
      redirect_to stuffs_path
    end
  end

  def show
    @stuff = Stuff.find(params[:id])

    add_breadcrumb "#{@stuff.patrimony.presence || "S/P"}".html_safe, :stuff_path
    @orders = @stuff.orders.page(params[:page]).per(5)

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

	def stuff_params
    params.require(:stuff).permit!
  end

  def schools
    @schools = School.all.collect {|s| [ s.name, s.id ] }
    @schools = @schools.sort_by {|label,code| Iconv.iconv('ascii//ignore//translit', 'utf-8', label).to_s}
  end
end