class StuffsController < ApplicationController
	autocomplete :stuff, :patrimony, full: true

	def index
		@stuffs = Stuff.all
	end
end