# encoding: utf-8
module Haoyaoshi
  module Api
    module Image
      
      def img_url(path)
        Haoyaoshi.img_endpoint(path)
      end

      private

        def image_interface_base_url
          ""
        end
    end
  end
end
