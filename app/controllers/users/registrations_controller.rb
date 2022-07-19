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

  def user_params
    params.require(:user).permit!
  end

  def load_schools
    require 'csv'

    path = "#{Rails.root}/public/schools.csv"
    file = File.open(path, "r:UTF-8")
    csv = CSV.parse(file, :headers => true, col_sep: ",")
    @schools = []
    csv.each do |r|
      common_name = r[1]
      full_name = r[0].nil? ? r[0] : " - #{r[0]}"
      @schools << "#{common_name} #{full_name}".to_s
    end
  end
end