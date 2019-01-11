module SessionsHelper
    def sign_in(user)
        #1.创建新权标； 2.把未加密的权标存入浏览器的cookie； 
        #3.把加密后的权标存入数据库； 4.把制定的用户设为当前登陆的用户
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
        user.update_attribute(:remember_token, User.encrypt(remember_token))
        self.current_user = user
    end

    #判断用户是否登陆
    def signed_in?
        #判断current_user 值不是nil 就说明用户登陆了
        !current_user.nil?
    end

    def current_user=(user)
        @current_user = user
    end

    #通过记忆权标查找用户
    def current_user
        remember_token = User.encrypt(cookies[:remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)
    end

    def current_user?(user) 
        user == current_user
    end

    def  signed_in_user 
        unless signed_in?
          store_location                      
          # notice 提示  unless：除非已经登陆
          redirect_to signin_url, notice: "请登陆."
        end
    end

    def sign_out
        self.current_user = nil
        cookies.delete(:remember_token)
    end

    #实现更有好的转向， session可以理解成和cookies类似的东西
    def redirect_back_or(default)
        redirect_to(session[:return_to] || default)
        session.delete(:return_to)
    end

    #使用fullpath方法获取了所请求页面的完整地址
    def store_location
        session[:return_to] = request.fullpath
    end
    
end
