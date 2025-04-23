class CreateJoinTableQuotesCategories < ActiveRecord::Migration[8.0]
  def change
    create_join_table :quotes, :categories do |t|
      t.index [:quote_id, :category_id]
      t.index [:category_id, :quote_id]
    end
  end
end
