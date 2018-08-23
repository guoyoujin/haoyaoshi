# encoding: utf-8
module Haoyaoshi
  module Token
    class RedisStore < Store

      def valid?
       haoyaoshi_redis.del(client.redis_key)
       super
      end

      def token_expired?
        haoyaoshi_redis.hvals(client.redis_key).empty?
      end

      def refresh_token
        super
        haoyaoshi_redis.hmset(
          client.redis_key, "access_token",
          client.access_token, "expired_at",
          client.expired_at, "token_type",
          client.token_type

        )
        haoyaoshi_redis.expireat(client.redis_key, client.expired_at.to_i)
      end

      def access_token
        super
        client.access_token = haoyaoshi_redis.hget(client.redis_key, "access_token")
        client.expired_at   = haoyaoshi_redis.hget(client.redis_key, "expired_at")
        client.token_type   = haoyaoshi_redis.hget(client.redis_key, "token_type")
        client.access_token
      end

      def haoyaoshi_redis
        Haoyaoshi.haoyaoshi_redis
      end
    end
  end

end
