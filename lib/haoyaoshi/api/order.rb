# encoding: utf-8
module Haoyaoshi
  module Api
    module Order

      def get_order_rx(params)
        create_url = "#{order_interface_base_url}/rx"
        http_get(create_url,params,"order")
      end

       def post_order_rx(params)
        create_url = "#{order_interface_base_url}/rx"
        http_post(create_url,params,{},"order")
      end

      def post_order(params)
        create_url = "#{order_interface_base_url}/orders"
        http_post(create_url,params,{},"order")
      end

      def post_order_prescription_url(params)
        create_url = "#{order_interface_base_url}/prescription/url"
        http_post(create_url,params,{},"order")
      end

      def post_order_prescription_img(params)
        create_url = "#{order_interface_base_url}/prescription/img"
        http_post(create_url,params,{},"order")
      end

      def delete_order(order_number = nil ,params = {})
        path_url = ""
        params = {}
        if order_number.present?
          path_url = "/#{order_number}"
        end
        create_url = "#{order_interface_base_url}/orders#{path_url}"
        http_delete(create_url,params,{},"order")
      end

      def delete_batch_order(order_number = nil,params = {})
        if order_number.present?
          params =  params.merge({orderNumber: order_number})
        end
        create_url = "#{order_interface_base_url}/orders/batchdelete"
        http_delete(create_url,params,"order")
      end

      private

        def order_interface_base_url
          "/order/v1.1"
        end
    end
  end
end
