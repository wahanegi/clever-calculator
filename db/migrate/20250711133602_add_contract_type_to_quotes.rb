class AddContractTypeToQuotes < ActiveRecord::Migration[8.0]
  def change
    add_reference :quotes, :contract_type, foreign_key: true
  end
end
