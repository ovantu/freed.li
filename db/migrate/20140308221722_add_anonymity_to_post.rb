class AddAnonymityToPost < ActiveRecord::Migration
  def change
    add_column :posts, :anonymity, :string
  end
end
