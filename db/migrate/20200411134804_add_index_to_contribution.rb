class AddIndexToContribution < ActiveRecord::Migration[6.0]
  def change
    add_index :contributions, :url, unique: true
  end
end