class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.integer :user_id
      t.integer :movie_id

      t.timestamps
    end

    add_index :histories, :user_id
    add_index :histories, :movie_id
    add_index :histories, [:user_id, :movie_id], unique: true
  end
end
