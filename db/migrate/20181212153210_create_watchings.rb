class CreateWatchings < ActiveRecord::Migration[5.2]
  def change
    create_table :watchings do |t|
      t.integer :user_id
      t.integer :episode_id
      t.integer :seconds, :default => 0

      t.timestamps
    end

    add_index :watchings, :user_id
    add_index :watchings, :episode_id
    add_index :watchings, [:user_id, :episode_id], unique: true
  end
end
