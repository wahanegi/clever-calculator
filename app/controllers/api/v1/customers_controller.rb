module Api
  module V1
    class CustomersController < BaseController
      def index
        customers = Customer.order(updated_at: :desc)
        render json: CustomerSerializer.new(customers).serializable_hash, status: :ok
      end

      def upsert
        customer = Customer.where('LOWER(company_name) = ?',
                                  customer_params[:company_name].downcase).first_or_initialize
        customer.assign_attributes(customer_params)
        if customer.save
          render json: CustomerSerializer.new(customer).serializable_hash, status: :ok
        else
          render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def customer_params
        params.expect(customer: [:company_name, :first_name, :last_name, :email, :position, :address,
                                 :notes, :logo])
      end
    end
  end
end
