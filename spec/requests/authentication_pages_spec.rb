require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "登陆页面" do
    before { visit signin_path }

    it { should have_content('登陆') }
    it { should have_title('登陆') }
  end

  describe "登陆" do
    before { visit signin_path }

    describe "信息无效" do
      before { click_button "登陆" }

      it { should have_title('登陆') }
      it { should have_selector('div.alert.alert-error', text: '无效') }

      describe "在访问另一页后" do
        before { click_link "主页" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "信息有效" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "电子邮箱", with: user.email.upcase
        fill_in "密码", with: user.password
        click_button "登陆"
      end

      it { should have_title(user.name) }
      it { should have_link('个人资料', href: user_path(user)) }
      it { should have_link('退出', href: signout_path) }
      it { should_not have_link('登陆', href: signin_path) }

      describe "用户退出" do
        before { click_link "退出" }
        it { should have_link('登陆') }
      end
    end 
  end
end
