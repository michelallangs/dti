class HomeController < ApplicationController
	def profile
		@school = current_user.school unless current_user.school.nil?
	end  
end