if Rails.env.development?
  contract_type_names = ['Initial Statement of Work', 'Scope Expansion Agreement', 'Renewal Agreement']

  if ContractType.count.zero?
    Rails.logger.info 'Creating contract types'
    contract_type_names.each do |name|
      ContractType.create!(name: name)
    end
  end
end
