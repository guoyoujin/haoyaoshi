# encoding: utf-8
module Haoyaoshi
  module Api
    module Drug
      
      def get_drug_list(params)
        create_url = "#{goods_interface_base_url}/syncGoodsInfoBatchService"
        http_drug_get(create_url,params,"syncGoodsInfoBatchService","open")
      end

      def get_drug_image(params)
        create_url = "#{goods_interface_base_url}/syncGoodsImagesBatchService"
        http_drug_get(create_url,params,"syncGoodsImagesBatchService","open")
      end

      def get_drug_price(params)
        create_url = "#{goods_interface_base_url}/queryUpdateInfoBatchService"
        http_drug_get(create_url,params,"queryUpdateInfoBatchService","open")
      end

      private

        def goods_interface_base_url
          "/goods-interface"
        end
    end
  end
end
