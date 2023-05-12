class HomeController < ApplicationController
	helper_method [:orders_per_user]

	def index
		@orders = Order.all
		@users = User.where("user_level = 0 AND is_technician = 'Sim'").order("name ASC")
		@last_orders = Order.order("updated_at DESC").first(5)	
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