class Users::RegistrationsController < Devise::RegistrationsController
  before_action :load_schools, only: [:new, :create, :edit, :update]

  def new
    @user = User.new
    @user.build_school
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Unidade cadastrada com sucesso!"
      redirect_to home_path
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      flash[:success] = "Dados atualizados com sucesso!"
      redirect_to profile_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:alert] = "Chamado excluído com sucesso!"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit!
  end

  def load_schools
    require 'csv'

    path = "#{Rails.root}/public/schools.csv"
    file = File.open(path, "r:ISO-8859-1:UTF-8")
    csv = CSV.parse(file, :headers => true, col_sep: ";")
    @schools = []
    csv.each do |r|
      common_name = r[3]
      full_name = r[2]
      common_name << " -" if !common_name.nil? && !full_name.nil?
      @schools << "#{common_name} #{full_name}".to_s
    end
  end
end