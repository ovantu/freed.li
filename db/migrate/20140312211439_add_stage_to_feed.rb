class AddStageToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :stage, :integer
  end
end
