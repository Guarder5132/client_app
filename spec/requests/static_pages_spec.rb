require 'spec_helper'

describe "静态页面" do
  
  subject {page}
  
  describe "主页页面" do
    before{ visit root_path }

    it { should have_content('G微博') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| 主页') }
  end
  
  describe "帮助页面" do
    before { visit help_path }

    it { should have_content('帮助') }
    it { should have_title(full_title('帮助')) }
  end

  describe "关于页面" do
    before { visit about_path }

    it { should have_content('关于我们') }
    it { should have_title(full_title('关于我们')) }
  end

  describe "联系页面" do
    before { visit contact_path }

    it { should have_content('联系') }
    it { should have_title(full_title('联系')) }
  end
end
