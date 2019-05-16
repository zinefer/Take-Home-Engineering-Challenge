class CreateBoroughs < ActiveRecord::Migration[5.2]
  def change
    create_table :boroughs do |t|
      t.string :name
      t.string :zone
      t.string :service_zone

      t.timestamps
    end
  end
end
