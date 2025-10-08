class CreateColleges < ActiveRecord::Migration[8.0]
  def change
    create_table :colleges do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.string :website

      t.timestamps
    end
  end
end
