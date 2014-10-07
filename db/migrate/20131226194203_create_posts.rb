class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :creator_id
      t.integer :feed_id
      t.string :status

      t.timestamps
    end
  end
end
