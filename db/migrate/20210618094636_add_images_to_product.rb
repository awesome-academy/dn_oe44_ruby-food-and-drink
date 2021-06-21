class AddImagesToProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
