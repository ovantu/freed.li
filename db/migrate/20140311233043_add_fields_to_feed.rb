class AddFieldsToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :contributor_count, :integer
    add_column :feeds, :last_activity, :datetime
  end
end
