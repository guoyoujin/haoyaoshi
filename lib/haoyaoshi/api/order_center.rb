# encoding: utf-8
module Haoyaoshi
  module Api
    module OrderCenter

      def get_syn_stock_info(params)
        create_url = "#{order_center_base_url}/syn-stock-info"
        http_get(create_url,params,"order_center")
      end

      private

        def order_center_base_url
          "/ordercenter/v1/stock"
        end
    end
  end
end
