module SessionsHelper
    def sign_in(user)
        #1.创建新权标； 2.把未加密的权标存入浏览器的cookie； 
        #3.把加密后的权标存入数据库； 4.把制定的用户设为当前登陆的用户
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
        user.update_attribute(:remember_token, User.encrypt(remember_token))
        self.current_user = user
    end

    def signed_in?
        #判断current_user 值不是nil 就说明用户登陆了
        !current_user.nil?
    end

    def current_user=(user)
        @current_user = user
    end

    def current_user
        remember_token = User.encrypt(cookies[:remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)
    end

    def current_user?(user) 
        user == current_user
    end

    def sign_out
        self.current_user = nil
        cookies.delete(:remember_token)
    end

    def redirect_back_or(default)
        redirect_to(session[:return_to] || default)
        session.delete(:return_to)
    end

    def store_location
        session[:return_to] = request.fullpath
    end
end
