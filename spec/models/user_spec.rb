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
  it {should respond_to(:authenticate)}
  it {should be_valid}

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
      before { @user.name = "a"*9 }
      it { should_not be_valid }
    end

    describe "期望最短长度等于10" do
      before { @user.name = "a"*10 }
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
end
