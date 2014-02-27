class AddFeedIdToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :feed_id, :integer
  end
end
