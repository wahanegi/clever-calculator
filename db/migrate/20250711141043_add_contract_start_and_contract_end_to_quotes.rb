class AddContractStartAndContractEndToQuotes < ActiveRecord::Migration[8.0]
  def change
    change_table :quotes, bulk: true do |t|
      t.date :contract_start_date
      t.date :contract_end_date
    end
  end
end
