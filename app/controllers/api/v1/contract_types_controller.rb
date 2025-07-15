module Api
  module V1
    class ContractTypesController < BaseController
      def index
        contract_types = ContractType.all

        render json: ContractTypesSerializer.new(contract_types).serializable_hash, status: :ok
      end
    end
  end
end
