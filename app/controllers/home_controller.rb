class HomeController < ApplicationController
	helper_method [:orders_per_user]
	include ApplicationHelper

	def index
		@users = User.where("is_technician = 'Sim'").order("name ASC")
		@orders = Order.all
		@orders = @orders.where('school_id = ?', current_user.school.id) if is_school?(current_user)
		@last_orders = @orders.order("updated_at DESC").first(5)	
	end

	def profile
		@school = current_user.school unless current_user.school.nil?
	end  

	def orders_per_user(orders, users)
		users.map { |user|
			{ user.name => orders.where("maintenance_technicians LIKE ? AND updated_at > ?", "%#{user.id}%", 30.days.ago).count }
		}.reduce(:merge)
	end
end