require 'spec_helper'

describe User do
  
  before do
    @user = User.new(name: "Example User", 
                     email: "user@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  subject { @user }

  #respond_to?方法，可以接受一个Symbol参数，
  #对象响应指定的方法或属性，返回true，则false
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token) }
  it {should respond_to(:authenticate)}
  it {should respond_to(:admin)} 
  #测试用户是否可以响应microposts方法
  it {should respond_to(:microposts)}
  #测试临时动态
  it {should respond_to(:feed)}
  it {should respond_to(:relationships)}
  it {should respond_to(:followed_users)}
  #测试关注关系用到的方法
  it {should respond_to(:following?)}  #用来检查一个用户是否关注其他用户
  it {should respond_to(:follow!)}     #用来创建关注
  it {should respond_to(:unfollow!)}   #用来取消关注
  it {should respond_to(:reverse_relationships)}
  it {should respond_to(:followers)}


  it {should be_valid}
  it {should_not be_admin}

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    # following接受一个用户对象作为参数， 检查这个被关注这的ID在数据库是否存在
    # follow!方法直接调用create！方法  通过Relationship 模型的关联来创建用户关系
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "将admin属性设置为true" do
    before do
      @user.save!
      #使用toggle！方法 把admin属性的值从false转换成true
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "记忆权标值" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "当名称不存在时" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "当电子邮件不存在时" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "当密码不存在时" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password:" ", password_confirmation: " ")
    end
    it {should_not be_valid}
  end 

  describe "当密码和确认密码不相同时" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "名字长度" do
    
    describe "当名字太长了" do
      before { @user.name = "a"*51 }
      it { should_not be_valid }
    end

    describe "期望最长长度等于50" do
      before {@user.name = "a"*50}
      it {should be_valid}
    end

    describe "当名字太短了" do
      before { @user.name = "a"*1 }
      it { should_not be_valid }
    end

    describe "期望最短长度等于10" do
      before { @user.name = "a"*2 }
      it { should be_valid }
    end
  end
  
  describe "密码太短了" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "验证方法的返回值" do
    before { @user.save }
    let(:found_user) {User.find_by(email: @user.email)}

    describe "有效密码" do
      #使用authenticate方法验证用户密码，密码一致返回用户对象，否则返回false
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "无效密码" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "当email格式无效时" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "当email格式有效时" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "当email邮箱地址被采取" do
    before do
      #@user.dup方法:创建一个和@user Email地址一样的用户
      user_with_same_email = @user.dup
      #不区分大小写
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    #应该以正确的顺序拥有正确的微博  .to_a 从初始状态转换从数组
    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end

    

    #测试用户删除后，所发布的微博是否也被删除
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy    
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
  end
end
