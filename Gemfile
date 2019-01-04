source 'https://gems.ruby-china.com'
#ruby的版本
ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'bootstrap-sass', '2.3.2.0'
gem 'rake', '<11.0'
#引进最先进的哈西函数bcrypt对密码进行不可逆的保密
gem 'bcrypt-ruby', '3.0.1'

#开发环境
group :development, :test do
  gem 'rubyzip', '0.9.9'
  #使用sqlite3作为Active Record的数据库
  gem 'sqlite3','1.3.7'
  #使用RSpec相关的生成器
  gem 'rspec-rails', '2.13.1'
end


group :test do
  gem 'selenium-webdriver', '2.0.0'
  #允许我们使用类是英语中的句法编写模拟与应用程序交互的代码
  gem 'capybara', '2.1.0'
end

#将SCSS用于样式表
gem 'sass-rails'
#使用Uglifier作为JavaScript资源的压缩器
gem 'uglifier',     '2.1.1'
#将CoffeeScript用于.js.coffee资产和视图
gem 'coffee-rails', '4.0.0'
#Use jquery as the JavaScript library
gem 'jquery-rails', '2.2.1'
#Turbolinks可以更快地在您的Web应用程序中建立以下链接。
gem 'turbolinks',   '1.1.1'
#轻松构建JSON API。
gem 'jbuilder',     '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end