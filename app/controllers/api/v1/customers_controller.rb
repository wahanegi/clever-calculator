module Api
  module V1
    class CustomersController < BaseController
      before_action :set_customer, only: [:upsert]

      def index
        customers = Customer.select('DISTINCT ON (company_name) *')
        render json: CustomerSerializer.new(customers).serializable_hash, status: :ok
      end

      def upsert
        @customer = Customer.find_or_initialize_by(company_name: customer_params[:company_name])
        @customer.assign_attributes(customer_params)
        if @customer.save
          render json: CustomerSerializer.new(@customer).serializable_hash, status: :ok
        else
          render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_customer
        @customer = Customer.find_by(company_name: customer_params[:company_name])
      end

      def customer_params
        params.expect(customer: [:company_name, :first_name, :last_name, :email, :position, :address,
                                 :notes])
      end
    end
  end
end
