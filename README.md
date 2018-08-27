# Haoyaoshi

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/haoyaoshi`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'haoyaoshi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install haoyaoshi

## Usage

#### 配置数据
```ruby
haoyaoshiNameSpace = Setting.haoyaoshi.name_space            #redis命名空间
exist_keys = redis.keys("#{haoyaoshiNameSpace}:*")           
exist_keys.each{|key|redis.del(key)}#每次重启时，会把当前的命令空间所有的access_token 清除掉。
redis = Redis.new(:driver => :hiredis, :host => redis_host, :port => redis_port, :db => 15, password: redis_password )

haoyaoshi_redis = Redis::Namespace.new("#{haoyaoshiNameSpace}", :redis => redis)
Haoyaoshi.configure do |config|
  config.redis = haoyaoshi_redis
  config.rest_client_options = {timeout: 100,read_timeout:1000, open_timeout: 100, verify_ssl: true}
  config.img_base_url = Setting.haoyaoshi.img_base_url      #图片地址http://img01.img.ehaoyao.com/
  config.open_base_url = Setting.haoyaoshi.open_base_url    #药品信息默认地址 http://test.api.goodscenter.ehaoyao.com
  config.api_base_url = Setting.haoyaoshi.api_base_url      #认证默认地址  https://api.ehaoyao.com/uat
  config.order_base_url = Setting.haoyaoshi.order_base_url  #订单默认地址https://api.ehaoyao.com/uat
  config.order_center_base_url = Setting.haoyaoshi.order_center_base_url #订单视客默认地址 https://internal.api.ehaoyao.com
end

$client_haoyaoshi ||= Haoyaoshi::Client.new(
  Setting.haoyaoshi.client_id,      #好药师给的client_id
  Setting.haoyaoshi.client_secret,  #好药师给的client_secret
  Setting.haoyaoshi.channel,        #好药师给的channel
  Setting.haoyaoshi.parnterkey,     #好药师给的parnterkey
  Setting.haoyaoshi.grant_type,     #好药师给的grant_type
  Setting.haoyaoshi.scope,          #好药师给的scope
  {redis_key: haoyaoshiNameSpace}   #存取在redis的表名
)
```
#### 获取药品
```ruby
 $client_haoyaoshi.get_drug_list({startDate: now_date.beginning_of_month.try(:strftime,"%Y-%m-%d"), endDate: now_date.end_of_month.try(:strftime,"%Y-%m-%d")})
```
#### 获取图片
```ruby
$client_haoyaoshi.get_drug_image({startDate:"2018-01-05",endDate:"2018-01-05"})
```
#### 获取库存
```ruby
$client_haoyaoshi.get_drug_price({startDate:"2018-01-05",endDate:"2018-01-05"})
```
#### 获取物流商
```ruby
$client_haoyaoshi.get_company({startDate:"2018-01-05",endDate:"2018-01-05"})
```

#### 获取电子发票
```ruby
$client_haoyaoshi.get_e_invoice_url("手机号","订单号")
```

#### 获取物流单号信息
```ruby
$client_haoyaoshi.get_deliveries("订单号")
```

#### 获取订单审核信息
```ruby
$client_haoyaoshi.get_order_rx({startTime: Time.now.at_beginning_of_day.try(:strftime,"%Y-%m-%d %H:%M:%S"),endTime: Time.now.try(:strftime,"%Y-%m-%d %H:%M:%S"),pageIndex: 1, pageSize: 20})
```
#### 同步订单发货状态
```ruby
$client_haoyaoshi.post_order({})
```

#### 推送订单审核
```ruby
$client_haoyaoshi.post_order_rx({})
```

#### 推送处方审核
```ruby
$client_haoyaoshi.post_order_prescription_url({})
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/haoyaoshi.

