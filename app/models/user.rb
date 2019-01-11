class User < ActiveRecord::Base
    #用户拥有多篇微博       dependent: :destroy保证用户的微博在删除用户的同时也会删除
    has_many :microposts, dependent: :destroy
    #把Email地址转换成全小写形式
    before_save { self.email = email.downcase }
    #before_create方法引用，当rails执行到这行代码时，回去寻找create_remember_token方法，  在创建用户字前
    before_create :create_remember_token
    #验证name和email属性的存在性
    validates :name,  presence: true, length: { maximum: 50 , minimum:2 }
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
        #to_s为了处理nil的情况
        Digest::SHA1.hexdigest(token.to_s)
    end

    def feed
        # This is preliminary. See "Following users" for the full implementation.
        Micropost.where("user_id = ?", id)
    end

    private

    def create_remember_token
        self.remember_token = User.encrypt(User.new_remember_token)
    end
end

