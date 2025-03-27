ActiveAdmin.register Note do
  menu false

  permit_params :notes, :is_printable, :quote_item_id

  index do
    selectable_column
    id_column
    column :notes
    column :is_printable
    actions
  end
end
