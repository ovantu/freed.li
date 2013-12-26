class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :goal
      t.string :rule1
      t.string :rule2
      t.string :rule3
      t.string :rule4
      t.string :rule5
      t.text :misc
      t.text :description
      t.string :lang
      t.string :status

      t.timestamps
    end
  end
end
