require 'spec_helper'

describe "静态页面" do
  
  describe "主页页面" do
    it "应该有内容'G微博'" do
      visit '/static_pages/home' 
      expect(page).to have_content('G微博')
    end
    
    it "应该有'主页'的标题" do
      visit '/static_pages/home'
      expect(page).to have_title("G微博 | 主页")
    end
  end

  describe "帮助页面" do
    it "应该有内容'帮助'"  do
      visit '/static_pages/help'
      expect(page).to have_content('帮助')
    end

    it "应该有'帮助'标题" do
      visit '/static_pages/help'
      expect(page).to have_title("G微博 | 帮助")
    end
  end

  describe "关于页面" do
    it "应该有内容'关于我们'" do
      visit '/static_pages/about'
      expect(page).to have_content('关于我们')
    end

    it "应该有'关于我们'标题" do
      visit '/static_pages/about'
      expect(page).to have_title("G微博 | 关于我们")
    end
  end
end
