# encoding: utf-8
module Haoyaoshi
  module Api
    module Stock

      def get_stock(productIds = nil ,params = {})
        create_url = "#{stock_interface_base_url}/stocks/#{productIds}"
        http_get(create_url,params,"order")
      end

      def get_branch_stocks(productIds = nil ,branchStockType = "ALL",params = {})
        create_url = "#{stock_interface_base_url}/branch-stocks/#{branchStockType}/#{productIds}"
        http_get(create_url,params,"order")
      end

      private

        def stock_interface_base_url
          "/stock/v1.1"
        end
    end
  end
end
