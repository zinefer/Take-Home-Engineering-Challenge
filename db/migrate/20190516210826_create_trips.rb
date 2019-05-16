# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.integer :vehicle_type
      t.datetime :pick_up_time
      t.datetime :drop_off_time
      t.references :pick_up_borough, foreign_key: { to_table: :boroughs }
      t.references :drop_off_borough, foreign_key: { to_table: :boroughs }
      t.float :fare

      t.timestamps
    end
  end
end
