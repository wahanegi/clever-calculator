ActiveAdmin.register Quote do
  permit_params :customer_id, :user_id,
                quote_items_attributes: [:id,
                                         :_destroy,
                                         :quote_id,
                                         :item_id,
                                         :open_parameters,
                                         :price,
                                         :discount,
                                         :final_price]

  filter :customer_name, as: :string, label: 'Customer Name'
  filter :user, as: :select, collection: proc {
    User.joins(:quotes).distinct.order(:email).map do |u|
      ["#{u.email} (#{u.name})", u.id]
    end
  }

  index do
    selectable_column
    id_column
    column 'Customer Name' do |quote|
      quote.customer.company_name
    end
    column 'Created By' do |quote|
      quote.user.name
    end
    column :total_price
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :customer, as: :select, collection: Customer.pluck(:company_name, :id)
      f.input :user, as: :select, collection: User.order(:email).map { |u| ["#{u.email} (#{u.name})", u.id] }
      f.input :total_price, input_html: { disabled: true }
    end
    f.inputs "Quote Items" do
      f.has_many :quote_items, allow_destroy: true, new_record: true do |qi|
        qi.input :item, as: :select, collection: Item.pluck(:name, :id)
        qi.input :open_parameters
        qi.input :price
        qi.input :discount
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row 'Customer Name' do |quote|
        quote.customer.company_name
      end
      row 'Created By' do |quote|
        quote.user.name
      end
      row :total_price
      row :created_at
    end
    panel 'Quote Items' do
      table_for quote.quote_items do
        column :item
        column :open_parameters
        column :price
        column :discount
        column :final_price
      end
    end
  end
end
