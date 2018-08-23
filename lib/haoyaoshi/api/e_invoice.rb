# encoding: utf-8
module Haoyaoshi
  module Api
    module EInvoice
      
      def get_e_invoice_url(moblie,order_number)
        create_url = "#{invoice_interface_base_url}/#{moblie}/#{order_number}"
         http_get(create_url,{},"api")
      end

      private

        def invoice_interface_base_url
          "/invoice/v1.1/e-invoice"
        end
    end
  end
end
