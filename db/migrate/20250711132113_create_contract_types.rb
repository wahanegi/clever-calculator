class CreateContractTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_types do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :contract_types, [:name], unique: true
  end
end
