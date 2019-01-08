class User < ActiveRecord::Base
    #把Email地址转换成全小写形式
    before_save { self.email = email.downcase }
    before_create :create_remember_token
    #验证name和email属性的存在性
    validates :name,  presence: true, length: { maximum: 50 , minimum:10 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    #通过 validates方法的 format 参数 指定合法的格式
    #uniqueness 保证了email地址的唯一性
    validates :email, presence: true,
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: {case_sensitive: false}
    #这行代码可以让所有针对密码的测试都通过，而且作用还不知如此。
    has_secure_password
    validates :password, length: { minimum: 6 }

    #加密
    def User.new_remember_token
        SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
        Digest::SHA1.hexdigest(token.to_s)
    end

    private

    def create_remember_token
        self.remember_token = User.encrypt(User.new_remember_token)
    end
end

