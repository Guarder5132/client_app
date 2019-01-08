class SessionsController < ApplicationController
    def new 
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            sign_in user
            redirect_to user
        else
            #flash.now 专门用来重新渲染页面中显示的flash，发送新的请求时，Flash便会消失
            flash.now[:error] = "电子邮箱或密码无效"
            render 'new'
        end
    end

    def destroy
    end
end
