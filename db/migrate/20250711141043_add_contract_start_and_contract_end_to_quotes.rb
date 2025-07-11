class AddContractStartAndContractEndToQuotes < ActiveRecord::Migration[8.0]
  def change
    add_column :quotes, :contract_start_date, :date
    add_column :quotes, :contract_end_date, :date
  end
end
