class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.integer :type
      t.datetime :pick_up_time
      t.datetime :drop_off_time
      t.references :pick_up_borough, foreign_key: true
      t.datetime :drop_off_burough
      t.float :fare

      t.timestamps
    end
  end
end
