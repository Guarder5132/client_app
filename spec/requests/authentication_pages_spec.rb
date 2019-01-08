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
      #have_selector方法会检查页面中是否出现了指定的元素
      it { should have_selector('div.alert.alert-error', text: '无效') }

      describe "访问另一个网页后" do
        before { click_link "主页" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "有效信息" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "电子邮箱",    with: user.email.upcase
        fill_in "密码",       with: user.password
        click_button "登陆"
      end

      it { should have_title(user.name) }
      it { should have_link('个人资料',   herf: user_path(user)) }
      it { should have_link('退出',      herf: signout_path) }
      it { should_not have_link('登陆'), herf: signin_path }
    end
  end
end
