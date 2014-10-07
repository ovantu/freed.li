class AddAnonymityToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :anonymity, :string
  end
end
