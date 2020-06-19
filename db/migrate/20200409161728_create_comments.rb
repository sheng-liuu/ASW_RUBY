class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :contribution, null: false, foreign_key: true
      t.references :comment, null: true, foreign_key: true
      t.boolean :voted, default: false
      t.integer :points, default: 0
      t.string :user_name, null: false
      t.timestamps
    end
  end
end
