class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes, if_not_exists: true do |t|
      t.references :quote, null: false, foreign_key: true
      t.references :quote_item, foreign_key: true
      t.text :notes, null: false
      t.boolean :is_printable, default: false

      t.timestamps
    end
  end
end
