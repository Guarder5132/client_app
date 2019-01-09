class UsersController < ApplicationController
  #只要运行:edit, :update  行动之前调用 signed_in_user  
  before_action :signed_in_user, only: [:index, :edit, :update,:destroy]
  before_action :correct_uesr,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "删除成功"
    redirect_to users_url
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "欢迎使用G微博"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "信息更改完成"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private 

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def  signed_in_user 
      unless signed_in?
        store_location                      
        # notice 提示  unless：除非已经登陆
        redirect_to signin_url, notice: "请登陆."
      end
    end

    def correct_uesr
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
