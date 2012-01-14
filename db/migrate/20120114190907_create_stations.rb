class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :space
      t.integer :idle
      t.integer :openTime
      t.integer :closeTime
      t.integer :cityId
      t.string :localId
      t.boolean :manual
      t.boolean :functioning

      t.timestamps
    end
  end
end
