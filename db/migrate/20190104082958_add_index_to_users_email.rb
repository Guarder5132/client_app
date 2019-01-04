class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    #调用了Rails 中的add_index方法，为users表的email列建立索引。
    #索引本身不能确保唯一性，所以还要指定unique: true
    add_index :users, :email, unique: true
  end
end
