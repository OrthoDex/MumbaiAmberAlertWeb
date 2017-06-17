class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :name
      t.integer :age
      t.integer :height
      t.text :remarks
      t.date :missing_date
      t.string :police_station
      t.string :police_reg_no
      t.bigint :reporter
      t.string :photo_url

      t.timestamps
    end
  end
end
