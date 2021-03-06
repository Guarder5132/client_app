require 'spec_helper'

describe "静态页面" do
  
  subject {page}

  #RSpec提供了一种名为“共享用例” 的辅助功能
  #let方法只要需要就会用指定的值创建一个局部变量
  shared_examples_for "所有静态页面" do
    # it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end
  
  it "应该在布局上有正确的链接" do
    visit root_path
    click_link "关于我们"
    expect(page).to have_title(full_title('关于我们'))
    click_link "帮助"
    expect(page).to have_title(full_title('帮助'))
    click_link "联系"
    expect(page).to have_title(full_title('联系'))
    click_link "主页"
    expect(page).to have_title(full_title(''))
    # click_link "立即注册"
    # expect(page).to have_title(full_title('注册'))
    click_link "GWB"
    expect(page).to have_title(full_title(''))
  end

  describe "主页页面" do
    before{ visit root_path }
    let(:heading)     { 'G微博' }
    let(:page_title)  { '' }

    it_should_behave_like "所有静态页面"
    it { should_not have_title('| 主页') }
  end
  
  describe "帮助页面" do
    before { visit help_path }
    let(:heading)     { '帮助' }
    let(:page_title)  { '帮助' }

    it_should_behave_like "所有静态页面"
  end

  describe "关于页面" do
    before { visit about_path }
    let(:heading)     { '关于我们' }
    let(:page_title)  { '关于我们' }

    it_should_behave_like "所有静态页面"
  end

  describe "联系页面" do
    before { visit contact_path }
    let(:heading)     { '联系' }
    let(:page_title)  { '联系' }

    it_should_behave_like "所有静态页面"
  end

  describe "for signed-in users" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
      FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
      sign_in user
      visit root_path
    end

    it "should render the user's feed" do
      user.feed.each do |item|
        expect(page).to have_selector("li##{item.id}", text: item.content)
      end
    end
    
    describe "follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit root_path
      end

      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
    end
  end
end
