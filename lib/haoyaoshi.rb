require "haoyaoshi/version"
require "rest-client"

if defined? Yajl
  require 'yajl/json_gem'
else
  require "json"
end
require "erb"

require "haoyaoshi/config"
require "haoyaoshi/handler"
require "haoyaoshi/api"
require "haoyaoshi/client"

module Haoyaoshi
  

  # token store
  module Token
    autoload(:Store,       "haoyaoshi/token/store")
    autoload(:ObjectStore, "haoyaoshi/token/object_store")
    autoload(:RedisStore,  "haoyaoshi/token/redis_store")
  end

  OK_MSG  = "ok".freeze
  OK_CODE = 0.freeze
  GRANT_TYPE = "client_credentials".freeze
  # 用于标记endpoint可以直接使用url作为完整请求API
  CUSTOM_ENDPOINT = "custom_endpoint".freeze

  class << self

    def http_get_without_token(url, url_params={}, endpoint="plain")
      get_api_url = endpoint_url(endpoint, url)
      Rails.logger.info("====好药师order请求参数===>#{get_api_url}===#{url_params}===#{endpoint}")
      load_json(resource(get_api_url).get(params: url_params))
    end

    def http_post_without_token(url, post_body={}, url_params={}, endpoint="plain")
      post_api_url = endpoint_url(endpoint, url)
      if endpoint == "plain" || endpoint == CUSTOM_ENDPOINT
        post_body = JSON.dump(post_body)
      else
        post_body = JSON.dump(post_body)
      end
      Rails.logger.info("====好药师order请求参数===>#{post_api_url}===#{post_body}=======#{url_params}=#{endpoint}")
      load_json(resource(post_api_url).post(post_body, params: url_params,raw_response: true,:content_type => :json))
    end

    def http_delete_without_token(url, delete_body={}, url_params={}, endpoint="plain")
      delete_api_url = endpoint_url(endpoint, url)
      if endpoint == "plain" || endpoint == CUSTOM_ENDPOINT
        delete_body = JSON.dump(delete_body)
      else
        delete_body = JSON.dump(delete_body)
      end
      Rails.logger.info("====好药师order请求参数===>#{delete_api_url}===#{delete_body}=======#{url_params}=#{endpoint}")
      load_json(resource(delete_api_url).delete(params: url_params,raw_response: true,:content_type => :json))
    end

    def resource(url)
      RestClient::Resource.new(url, rest_client_options)
    end

    # return hash
    def load_json(string)
      result_hash = JSON.parse(string.force_encoding("UTF-8").gsub(/[\u0011-\u001F]/, ""))
      if result_hash.present?
        code   = result_hash.delete("errcode")
        en_msg = result_hash.delete("errmsg")
      else
        result_hash = {}
        code   = 0
        en_msg = "请求成功"
      end
      ResultHandler.new(code, en_msg, result_hash)
    end

    def endpoint_url(endpoint, url)
      # 此处为了应对第三方开发者如果自助对接接口时，URL不规范的情况下，可以直接使用URL当为endpoint
      return url if endpoint == CUSTOM_ENDPOINT
      Rails.logger.info("#{endpoint}_endpoint")
      send("#{endpoint}_endpoint") + url
    end

    def plain_endpoint
      "#{api_endpoint}"
    end

    def api_endpoint
      api_base_url
    end

    def order_endpoint
      order_base_url
    end

    def order_center_endpoint
      order_center_base_url
    end

    def token_endpoint(url)
      "#{api_endpoint}#{url}"
    end

    def open_endpoint
      open_base_url
    end

    def img_endpoint(url)
      "#{img_base_url}#{url}"
    end

    def calculate_expire(expires_in)
      Time.now.to_i + expires_in.to_i - key_expired.to_i
    end

  end

end