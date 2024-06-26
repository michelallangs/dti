class HomeController < ApplicationController
	helper_method [:orders_per_user]

	def index
		@users = User.where("is_technician = 'Sim'").order("name ASC")
		@orders = Order.all
		@orders = @orders.where('school_id = ?', current_user.school.id) if is_school?(current_user)
		@last_orders = @orders.order("updated_at DESC").first(5)	
		status = ["Em manutenção", "Para retirada", "Concluído"]
		@orders_last_month = @orders.where("status IN (?) AND (EXTRACT(MONTH FROM updated_at))::integer = ?", status, 1.month.ago.month).count
    @orders_last_2_months = @orders.where("status IN (?) AND (EXTRACT(MONTH FROM updated_at))::integer = ?", status, 2.months.ago.month).count
    @orders_last_3_months = @orders.where("status IN (?) AND (EXTRACT(MONTH FROM updated_at))::integer = ?", status, 3.months.ago.month).count
    @orders_last_4_months = @orders.where("status IN (?) AND (EXTRACT(MONTH FROM updated_at))::integer = ?", status, 4.months.ago.month).count
	end

	def profile
		add_breadcrumb "meu perfil".html_safe, :profile_path

		if is_school?(current_user)
			@school = current_user.school 
			@stuffs = @school.stuffs.page(params[:stuffs_page]).per(5)
		end

		list = []
    Order.all.map { |o| list << o if o.maintenance_technicians.include? current_user.id.to_s }
		@orders = is_school?(current_user) ? @school.orders : Order.where(id: list.pluck(:id))
		@orders = @orders.page(params[:orders_page]).per(5)

		respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
	end  

	def orders_per_user(orders, users)
		users.map { |user|
			{ user.first_name => orders.where("maintenance_technicians LIKE ? AND updated_at > ?", "%#{user.id}%", 30.days.ago).count }
		}.reduce(:merge)
	end
end