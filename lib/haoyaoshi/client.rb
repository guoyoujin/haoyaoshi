# encoding: utf-8
require "monitor"
require "redis"
require 'digest/md5'
module Haoyaoshi

  class Client

    include MonitorMixin

    include Api::Drug
    include Api::Order
    include Api::Logistics
    include Api::Image
    include Api::EInvoice
    include Api::Stock
    include Api::OrderCenter

    attr_accessor :client_id, :client_secret, :channel, :parnterkey, :grant_type, :scope, :expired_at # Time.now + expires_in
    attr_accessor :access_token, :token_type, :redis_key, :custom_access_token, :token_type_token

    # options: redis_key, custom_access_token
    def initialize(client_id, client_secret, channel , parnterkey, grant_type = "client_credentials" , scope = "order", options={})
      @client_id = client_id
      @client_secret = client_secret
      @expired_at = Time.now.to_i
      @channel = channel
      @parnterkey = parnterkey
      @grant_type =  grant_type if grant_type.present?
      @scope = scope
      @redis_key = security_redis_key(options[:redis_key] || "haoyaoshi_#{client_id}")
      @custom_access_token = options[:custom_access_token]
      @custom_token_type = options[:custom_token_type]
      super() # Monitor#initialize
    end

    # return token
    def get_access_token
      return custom_access_token if !custom_access_token.nil?
      synchronize{ token_store.access_token }
    end

    # return token
    def get_token_type
      return custom_token_type if !custom_token_type.nil?
      synchronize{ token_store.token_type }
    end

    # 检查appid和app_secret是否有效。
    def is_valid?
      return true if !custom_access_token.nil?
      token_store.valid?
    end

    def token_store
      Token::Store.init_with(self)
    end

    # 暴露出：http_get,http_post两个方法，方便第三方开发者扩展未开发的微信API。
    def http_get(url, url_params={}, endpoint="plain")
      url_params = url_params.merge(access_token_param)
      Haoyaoshi.http_get_without_token(url, url_params, endpoint)
    end

    def http_post(url, post_body={}, url_params={}, endpoint="plain")
      url_params = access_token_param.merge(url_params)
      Haoyaoshi.http_post_without_token(url, post_body, url_params, endpoint)
    end

    def http_delete(url, delete_body={}, url_params={}, endpoint="plain")
      url_params = access_token_param.merge(url_params)
      url = "#{url}?access_token=#{get_access_token}"
      Haoyaoshi.http_delete_without_token(url, delete_body, url_params, endpoint)
    end

    # 暴露出：http_get,http_post两个方法，方便第三方开发者扩展未开发的微信API。
    def http_drug_get(url, url_params = {}, path = nil, endpoint="plain")
      url_params = {channel: @channel}.merge(url_params)
      tmp_option = url_params.deep_dup
      url_params[:sign] = sign(tmp_option,path)
      Rails.logger.info("#{url_params[:sign]}")
      Haoyaoshi.http_get_without_token(url, url_params, endpoint)
    end

    private

      def access_token_param
        {access_token: get_access_token}
      end

      def security_redis_key(key)
        Digest::MD5.hexdigest(key.to_s).upcase
      end

      #生成签名
      def sign(params,path)
        option = params.sort().collect{|key,value| "#{key}#{value.to_s}"}.join
        Rails.logger.info("#{path}#{option.to_s}#{@parnterkey}")
        Digest::SHA1.hexdigest("#{path}#{option.to_s}#{@parnterkey}")
      end

  end
end
