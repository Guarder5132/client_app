class User < ActiveRecord::Base
    #用户拥有多篇微博       dependent: :destroy保证用户的微博在删除用户的同时也会删除
    has_many :microposts, dependent: :destroy
    #实现User和Relationship模型之间has_many的关联关系
    has_many :relationships, foreign_key:"follower_id", dependent: :destroy
    #在User模型中添加followed_users关联 
    #source 参数，告知Rails followed_users数组的来源是 followed所代表的ID集合
    has_many :followed_users, through: :relationships, source: :followed
    #通过反转的关系实现user.followers
    has_many :reverse_relationships, foreign_key: "followed_id",
                                     class_name:  "Relationship",
                                     dependent: :destroy
    has_many :followers, through: :reverse_relationships, source: :follower
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
    Micropost.from_users_followed_by(self)
    end

    def following?(other_user) 
        relationships.find_by(followed_id: other_user.id)
    end

    def follow!(other_user)
        relationships.create!(followed_id: other_user.id)
    end

    def unfollow!(other_user)
        relationships.find_by(followed_id: other_user.id).destroy
    end

    private

    def create_remember_token
        self.remember_token = User.encrypt(User.new_remember_token)
    end
end

