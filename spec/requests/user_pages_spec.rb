require 'spec_helper'

describe "User pages" do
  
    subject {page}

    describe "index" do
        let(:user) { FactoryGirl.create(:user) }
        before(:each) do
            sign_in user
            visit users_path
        end

        it { should have_title('所有用户') }
        it { should have_content('所有用户') }

        describe "分页" do
            before(:all) {30.times { FactoryGirl.create(:user) }}
            after(:all)  {User.delete_all}

            it { should have_selector('div.pagination') }

            it "应列出每个用户" do
                User.paginate(page:1).each do |user|
                    expect(page).to have_selector('li', text: user.name)
                end
            end
        end

        describe "删除链接" do
            it { should_not have_link('delete') }

            describe "为管理员用户" do
                let(:admin) {FactoryGirl.create(:admin)}
                before do
                    sign_in admin
                    visit users_path
                end

                it { should have_link('delete'), href: user_path(User.first) }
                it "应该能够删除另一个用户" do
                    expect do
                        click_link('delete', match: :first)
                    end.to change(User, :count).by(-1)
                end
                it { should_not have_link('delete', href: user_path(admin)) }
            end
        end
    end

    describe "编辑" do
        let(:user) { FactoryGirl.create(:user) }
        before do
            sign_in user
            visit edit_user_path(user)
        end

        describe " page " do
            it { should have_content("更新个人资料") }
            it { should have_title("编辑用户") }
            it { should have_link('更改', href: 'http://gravatar.com/emails') }
        end

        describe "信息无效" do
            before { click_button "保存更改" }

            it { should have_content('error') }
        end

        describe "信息有效" do
            let(:new_name) {"New name"}
            let(:new_email){"new@example.com"}
            before do
                fill_in "用户名",         with:new_name
                fill_in "电子邮箱",        with:new_email
                fill_in "密码",           with:user.password
                fill_in "确认密码",        with:user.password
                click_button "保存更改"
            end

            it { should have_title(new_name) }
            it { should have_selector('div.alert.alert-success') }
            it { should have_link('退出', href:signout_path) }
            specify { expect(user.reload.name).to eq new_name }
            specify { expect(user.reload.email).to eq new_email }
        end
    end

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

            describe "after submission" do
                before { click_button submit }

                it { should have_title('注册') }
                it { should have_content('error') }
            end
        end

        describe "有效信息" do
            before do
                fill_in "用户名",   with: "Guard_tuzi"
                fill_in "电子邮箱",  with: "Guard@exmaple.com"
                fill_in "密码",     with: "Guarder"
                fill_in "确认密码",  with: "Guarder"
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
