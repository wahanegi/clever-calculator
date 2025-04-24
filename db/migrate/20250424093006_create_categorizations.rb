class CreateCategorizations < ActiveRecord::Migration[8.0]
  def change
    create_table :categorizations do |t|
      t.references :quote, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
