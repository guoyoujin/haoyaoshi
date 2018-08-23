module Haoyaoshi

  class << self

    attr_accessor :config

    def configure
      yield self.config ||= Config.new
    end

    def haoyaoshi_redis
      return nil if config.nil?
      @redis ||= config.redis
    end

    def key_expired
      if config.nil?
        return 100
      end
      @key_expired ||= config.key_expired
    end

    def img_base_url
      if config.nil?
        return "http://img01.img.ehaoyao.com"
      end
      @img_base_url ||= config.img_base_url
    end

    def open_base_url
      if config.nil?
        return "http://api.goodscenter.ehaoyao.com"
      end
      @open_base_url ||=  config.open_base_url
    end

    def api_base_url
      if config.nil?
        return "https://api.ehaoyao.com"
      end
      @api_base_url ||=  config.api_base_url
    end

    def order_base_url
      if config.nil?
        return "https://api.ehaoyao.com"
      end
      @order_base_url ||= config.order_base_url
    end

    def order_center_base_url
      if config.nil?
        return "https://internal.api.ehaoyao.com"
      end
      @order_center_base_url ||= config.order_center_base_url
    end

    # 可选配置: RestClient timeout, etc.
    # key 必须是符号
    # 如果出现 RestClient::SSLCertificateNotVerified Exception: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
    # 这个错，除了改 verify_ssl: true，请参考：http://www.extendi.it/blog/2015/5/23/47-sslv3-read-server-certificate-b-certificate-verify-failed
    def rest_client_options
      if config.nil?
        return {timeout: 5, open_timeout: 5, verify_ssl: true}
      end
      @rest_client_options ||= config.rest_client_options
    end
  end

  class Config
    attr_accessor :redis, :rest_client_options, :key_expired, :img_base_url, :open_base_url,:api_base_url, :order_base_url, :order_center_base_url
  end
end
