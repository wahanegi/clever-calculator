module Api
  module V1
    class CustomersController < BaseController
      def index
        customers = Customer.select('DISTINCT ON (company_name) *')
        render json: CustomerSerializer.new(customers).serializable_hash, status: :ok
      end

      def upsert
        # TODO: Add service class that would receive params and finds existing Customer
        # based on all attributes or creates it. Also assigns customer to quote.
      end
    end
  end
end
