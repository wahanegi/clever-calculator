ActiveAdmin.register Quote do
  permit_params :customer_id, :user_id

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
      "#{quote.customer.first_name} #{quote.customer.last_name}"
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
      f.input :customer, as: :select, collection: Customer.pluck(:first_name, :last_name, :id).map do |c|
        ["#{c[0]} #{c[1]}", c[2]]
      end
      f.input :user, as: :select, collection: User.order(:email).map { |u| ["#{u.email} (#{u.name})", u.id] }
      f.input :total_price, input_html: { disabled: true }
    end
    f.actions
  end

  show do
    attributes_table do
      row 'Customer Name' do |quote|
        "#{quote.customer.first_name} #{quote.customer.last_name}"
      end
      row 'Created By' do |quote|
        quote.user.name
      end
      row :total_price
      row :created_at
    end
  end
end
