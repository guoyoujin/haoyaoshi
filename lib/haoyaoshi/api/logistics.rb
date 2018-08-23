# encoding: utf-8
module Haoyaoshi
  module Api
    module Logistics
      
      def get_company(params)
        create_url = "#{logistics_interface_base_url}/company"
        http_get(create_url,params,"order")
      end

      def get_deliveries_list(params)
        create_url = "#{logistics_interface_base_url}/deliveries"
        http_get(create_url,params,"order")
      end

      def get_deliveries(orderNumber)
        create_url = "#{logistics_interface_base_url}/deliveries/#{orderNumber}"
        http_get(create_url,{orderNumber: orderNumber},"order")
      end

      private

        def logistics_interface_base_url
          "/logistics/v1.1"
        end
    end
  end
end
