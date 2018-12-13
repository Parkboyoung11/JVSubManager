class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.integer :movie_id
      t.string :name, :limit => 100
      t.string :image
      t.string :video

      t.timestamps
    end

    add_index :episodes, :movie_id
  end
end
