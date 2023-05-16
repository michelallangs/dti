class StuffsController < ApplicationController
	autocomplete :stuff, :patrimony, full: true
	include ApplicationHelper

	def index
		id = params[:id]
		patrimony = params[:patrimony]
    category = params[:category]
    brand = params[:brand]
    @search = [id, patrimony, category, brand]

    @stuffs = Stuff.joins(:school)

    if !@search.all?(&:blank?)
    	patrimony = patrimony.downcase == "s/p" ? "" 
    																					: "%#{patrimony}%"

    	query = "patrimony LIKE ? AND lower(category) LIKE lower(?) AND lower(brand) LIKE lower(?)"

      values = [patrimony, "%#{category}%", "%#{brand}%"]

      if !id.blank?
        query += " AND stuffs.id LIKE ?"
        values += [id]
      end

      @stuffs = @stuffs.where(query, *values)
    else
    	@stuffs = @stuffs.where("schools.user_id = ?", current_user.id) if is_school?
    end


	 	@stuffs = @stuffs.order("#{params[:sort_by]} ASC") if params[:sort_by]

    @stuffs_paginate = @stuffs.page(params[:page]).per(params[:limit])
	end

  def new
    @stuff = Stuff.new
    @schools = School.all.collect {|s| [ s.name, s.id ] }
    @schools = @schools.sort_by {|label,code| Iconv.iconv('ascii//ignore//translit', 'utf-8', label).to_s}
  end

  def create
    @stuff = Stuff.new(stuff_params)

    @schools = School.all.collect {|s| [ s.name, s.id ] }
    @schools = @schools.sort_by {|label,code| Iconv.iconv('ascii//ignore//translit', 'utf-8', label).to_s}

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

	def stuff_params
    params.require(:stuff).permit!
  end
end