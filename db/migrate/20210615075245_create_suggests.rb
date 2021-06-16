class CreateSuggests < ActiveRecord::Migration[6.0]
  def change
    create_table :suggests do |t|
      t.string :name
      t.string :infor
      t.integer :status

      t.timestamps
    end
  end
end
