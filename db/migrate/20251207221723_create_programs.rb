class CreatePrograms < ActiveRecord::Migration[8.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.references :organization, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
