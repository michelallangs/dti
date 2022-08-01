class UsersController < ApplicationController
	def edit_password
		@user = current_user
	end

	def update_password
		@user = current_user

		if @user.update(user_params)
      flash[:success] = "Senha atualizada com sucesso!"
      redirect_to profile_path
    else
      render :edit
    end
	end

	def user_params
		params.require(:user).permit!
	end
end