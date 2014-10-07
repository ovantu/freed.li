class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :type
      t.boolean :goal
      t.boolean :rule1
      t.boolean :rule2
      t.boolean :rule3
      t.boolean :rule4
      t.boolean :rule5
      t.text :comment
      t.string :status

      t.timestamps
    end
  end
end
