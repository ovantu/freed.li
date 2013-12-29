class AddCreatorIdToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :creator_id, :integer
  end
end
