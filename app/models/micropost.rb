class Micropost < ActiveRecord::Base
    #微博属于用户
    belongs_to :user
    #通过default_scope设定微博的降序
    default_scope -> { order('created_at DESC') }
    validates :content, presence:true, length: { maximum:140 }
    validates :user_id, presence:true
end
