require 'spec_helper'

describe "User pages" do
  
    subject {page}

    describe "用户资料页面" do
        let(:user) { FactoryGirl.create(:user) } 
        before { visit user_path(user) }
        
        it { should have_content(user.name) }
        it { should have_title(user.name) }
    end
    
    describe "注册页面" do
        before { visit signup_path }

        it { should have_content('注册') }
        it { should have_title(full_title('注册')) }
    end

    describe "注册" do

        before { visit signup_path }

        let(:submit) { "Create my account" }

        describe "信息无效" do
            it "不能创建用户" do
                expect { click_button submit }.not_to change(User, :count)
            end
        end

        describe "有效信息" do
            before do
                fill_in "用户名",         with: "Guard_tuzi"
                fill_in "电子邮箱",        with: "Guard@exmaple.com"
                fill_in "密码",     with: "Guarder"
                fill_in "确认密码", with: "Guarder"
            end

            it "能创建一个用户" do
                expect { click_button submit }.to change(User, :count).by(1)
            end

            describe "注册用户后" do
                before { click_button submit }
                let(:user) { User.find_by(email: 'user@example.com') }

                it { should have_link( '退出' ) }
                #it { should have_title(user.name) }
                it { should have_selector('div.alert.alert-success', text: '欢迎使用G微博') }
            end
        end
    end 
end
