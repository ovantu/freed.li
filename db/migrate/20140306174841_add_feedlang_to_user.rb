class AddFeedlangToUser < ActiveRecord::Migration
  def change
    add_column :users, :feedlang, :text
  end
end
