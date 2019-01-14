require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "授权" do

    describe "作为非管理员" do
      let(:user) {FactoryGirl.create(:user)}
      let(:non_admin) {FactoryGirl.create(:user)}

      before { sign_in non_admin, no_capybara:true }

      describe "向用户提交DELETE请求#删除行动" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "于非登陆用户" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in thr Relationships controller" do
        describe "submitting to the create action" do
          before {post relationships_path}
          specify {expect(response).to redirect_to(signin_path)}
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
     
      describe "in the Microposts controller" do

        #向/microposts发送post请求, 会转向到登陆页面
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        #向/microposts/1发送delete请求, 会转向到登陆页面
        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) } 
        end
      end

      describe "尝试访问受保护的页面时" do
        before do
          visit edit_user_path(user)
          fill_in "电子邮箱",  with: user.email
          fill_in "密码",     with: user.password
          click_button "登陆"
        end

        describe "登陆后" do
          
          it "应呈现所需的受保护页面" do
            expect(page).to have_title('编辑用户')
          end
        end
      end

      describe "在用户控制器中" do
        before { visit edit_user_path(user) }
        it { should have_title('登陆') }

        describe "访问用户索引" do
          before { visit users_path }
          it { should have_title('登陆') }
        end

        #测试关注列表和粉丝列表的访问权限
        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('登陆') }
        end

        describe "visiting the followes page" do
          before { visit followers_user_path(user) }
          it { should have_title('登陆') }
        end
      end

      describe "提交更新操作" do
        before { patch user_path(user) }
        #response 测试服务器响应   redirect_to重定向到登陆界面
        specify { expect(response).to redirect_to(signin_path) }
      end
    end

    describe "用户错误" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "访问用户#编辑页面" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('编辑用户')) }
      end

      describe "向用户提交PATCH请求#更新" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end

  
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
      it { should_not have_title('退出') }
      it { should_not have_link('退出', href:signout_path)}

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
    
    describe "有效信息" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('所有用户', href: users_path) }
      it { should have_link('个人资料', href: user_path(user)) }
      it { should have_link('修改信息', href: edit_user_path(user)) }
      it { should have_link('退出', href: signout_path) }
      it { should_not have_link('登陆', href: signin_path) }
    end
  end
end
