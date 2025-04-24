class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.text :style

      t.timestamps
    end
  end
end
