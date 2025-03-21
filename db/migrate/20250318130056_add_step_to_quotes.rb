class AddStepToQuotes < ActiveRecord::Migration[8.0]
  def change
    add_column :quotes, :step, :string, default: 'customer_info', null: false
  end
end
