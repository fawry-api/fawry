[![CircleCI](https://circleci.com/gh/fawry-api/fawry.svg?style=svg)](https://circleci.com/gh/fawry-api/fawry)

# Fawry

[README - متوفر باللغة العربية](https://github.com/fawry-api/fawry/blob/master/README-ar.md)

**Disclaimer:** we are _not officially affilated_ with the _Fawry_ company.

A plug-and-play library that makes interfacing with Fawry's payment gateway API a breeze:

_Fawry's production and sandbox environments are supported._

_This library is tested on Ruby v2.6, 2.7, 3.0_

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fawry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fawry
    
## Configuration

Add an initializer `fawry.rb` in your application to configure the library:
```ruby
Fawry.configure do |config|
  config.sandbox = Rails.env.staging?
  config.fawry_secure_key = 'fawry_secure_key'
  config.fawry_merchant_code = 'fawry_merchant_code'
end
```
Alternatively, you could use the environment variables: `FAWRY_SANDBOX`, `FAWRY_SECURE_KEY`, and `FAWRY_MERCHANT_CODE`.

## Usage

### Charge customers

```ruby
params = { "merchant_code": 'merchant_code',
           "merchant_ref_num": 'io5jxf3jp27kfh8m719arcqgw7izo7db',
           "customer_profile_id": 'ocvsydvbu2gcp528wvl64i9z5srdalg5',
           "customer_mobile": '012345678901',
           "payment_method": 'PAYATFAWRY',
           "currency_code": 'EGP',
           "amount": 20,
           "fawry_secure_key": 'fawry_secure_key',
           "description": 'the charge request description',
           "charge_items": [{ "item_id": 'fk3fn9flk8et9a5t9w3c5h3oc684ivho',
                              "description": 'desc', "price": 20, "quantity": 1 }] }

res = Fawry.charge(params)
#  => #<Fawry::FawryResponse:0x0000564257d0ea90 @type="ChargeResponse", @reference_number="931600239",
#                                               @merchant_ref_number="io5jxf3jp27kfh8m719arcqgw7izo7db",
#                                               @expiration_time=1573153206979, @status_code=200,
#                                               @status_description="Operation done successfully">

res.success? # => true
res.reference_number # => 931600239
```

### Refund Customers

```ruby
params = { "merchant_code": 'merchant_code',
           "reference_number": '931337410',
           "refund_amount": 20,
           "fawry_secure_key": 'fawry_secure_key' }

res = Fawry.refund(params)
#  => #<Fawry::FawryResponse:0x0000564257d0ea90 @type="ResponseDataModel", @status_code=200,
#                                               @status_description="Operation done successfully">

res.success? # => true
```

### Get Payment Status

```ruby
params = { "merchant_code": 'merchant_code',
           "merchant_ref_number": 'ssshxb98phmyvm434es62kage3nsm2cj',
           "fawry_secure_key": 'fawry_secure_key' }

res = Fawry.payment_status(params)
 # => #<Fawry::FawryResponse:0x0000559974056898 @type="PaymentStatusResponse", @reference_number="931922417",
 #                                              @merchant_ref_number="ssshxb98phmyvm434es62kage3nsm2cj",
 #                                              @expiration_time=1573297736167, @status_code=200,
 #                                              @status_description="Operation done successfully", @payment_amount=20,
 #                                              @payment_method="PAYATFAWRY", @payment_status="UNPAID">

res.success? # => true
res.payment_status # => UNPAID
```

### List Card Tokens

```ruby
params = { "merchant_code": 'merchant_code',
           "customer_profile_id": 'customer_profile_id',
           "fawry_secure_key": 'fawry_secure_key' }

res = Fawry.list_tokens(params)
#<Fawry::FawryResponse:0x0000556cb3a31798 @fawry_api_response={"type"=>"CustomerTokensResponse", "cards"=>[{"token"=>"b5sshhdsl98df96200f254c19b2718bfc825a0678888216c28962b3e66a393084ee9aed6", "creationDate"=>1599487402318, "lastFourDigits"=>"4242", "brand"=>"Visa Card"}, {"token"=>"fb98dslsksmkdds7857ed7042ce30a2a5b777e1f1ac6ac58da1c8c0199f61df7a8bc098e96", "creationDate"=>1599489158457, "lastFourDigits"=>"0001", "brand"=>"Visa Card"}, {"token"=>"cc03fwqaacbd94e468a1b756ac1cbb285a41a2428df9f1a727457b41f9447d0058c7c", "creationDate"=>1599584834346, "lastFourDigits"=>"2346", "brand"=>"MasterCard"}, {"token"=>"f04a8bc9c973f900515f4b58e52c9ff03070baf3f534bdfdad0e97679534f60ddkjk13", "creationDate"=>1600260415739, "lastFourDigits"=>"8769", "brand"=>"Visa Card"}], "statusCode"=>200, "statusDescription"=>"Operation done successfully"}, @type="CustomerTokensResponse", @cards=[{"token"=>"b5sshhdsl98df96200f254c19b2718bfc825a0678888216c28962b3e66a393084ee9aed6", "creationDate"=>1599487402318, "lastFourDigits"=>"4242", "brand"=>"Visa Card"}, {"token"=>"fb98dslsksmkdds7857ed7042ce30a2a5b777e1f1ac6ac58da1c8c0199f61df7a8bc098e96", "creationDate"=>1599489158457, "lastFourDigits"=>"0001", "brand"=>"Visa Card"}, {"token"=>"cc03fwqaacbd94e468a1b756ac1cbb285a41a2428df9f1a727457b41f9447d0058c7c", "creationDate"=>1599584834346, "lastFourDigits"=>"2346", "brand"=>"MasterCard"}, {"token"=>"f04a8bc9c973f900515f4b58e52c9ff03070baf3f534bdfdad0e97679534f60ddkjk13", "creationDate"=>1600260415739, "lastFourDigits"=>"8769", "brand"=>"Visa Card"}], @status_code=200, @status_description="Operation done successfully">

res.success? # => true
res.cards # => cards
```

### Create Card Token

```ruby
params = { "merchant_code" : "merchant_code",
            "customer_profile_id" : "customer_profile_id",
            "customer_mobile" : "customer_mobile",
            "customer_email" : "customer_email",
            "card_number" : "card_number",
            "expiry_year" : "expiry_year",
            "expiry_month" : "expiry_month",
            "cvv" : "cvv" }
res = Fawry.create_card_token(params)
#<Fawry::FawryResponse:0x0000556cb3eb0080 @fawry_api_response={"type"=>"CardTokenResponse", "card"=>{"token"=>"b598f96200f254c19b2718bfc825a063278888216c28962b3e66a393084ee9aed6", "creationDate"=>1607011562353, "lastFourDigits"=>"4242"}, "statusCode"=>200, "statusDescription"=>"Operation done successfully"}, @type="CardTokenResponse", @status_code=200, @status_description="Operation done successfully", @card={"token"=>"b598f96200f254c19b2718bfc825a063278888216c28962b3e66a393084ee9aed6", "creationDate"=>1607011562353, "lastFourDigits"=>"4242"}>

res.success?
res.card
```

### Delete Card Token

```ruby
params = { "merchant_code": "merchant_code",
           "customer_profile_id": "customer_profile_id",
           "card_token": "card_token",
           "fawry_secure_key": "fawry_secure_key" }

res = Fawry.delete_token(params)
#<Fawry::FawryResponse:0x0000556cb57c2460 @fawry_api_response={"type"=>"CardTokenResponse", "statusCode"=>200, "statusDescription"=>"Operation done successfully"}, @type="CardTokenResponse", @status_code=200, @status_description="Operation done successfully">

res.success?

```

### Parse Fawry service callback v2

```ruby
# params sent from fawry server
callback_params = { "requestId": 'c72827d084ea4b88949d91dd2db4996e', "fawryRefNumber": '970177',
                    "merchantRefNumber": '9708f1cea8b5426cb57922df51b7f790',
                    "customerMobile": '01004545545', "customerMail": 'fawry@fawry.com',
                    "paymentAmount": 152.00, "orderAmount": 150.00, "fawryFees": 2.00,
                    "shippingFees": '', "orderStatus": 'NEW', "paymentMethod": 'PAYATFAWRY',
                    "messageSignature": 'b0175565323e464b01dc9407160368af5568196997fb6e379374a4f4fbbcf587',
                    "orderExpiryDate": 1_533_554_719_314,
                    "orderItems": [{ "itemCode": 'e6aacbd5a498487ab1a10ae71061535d', "price": 150.0, "quantity": 1 }] }

fawry_callback = Fawry.parse_callback(callback_params)
# <Fawry::FawryCallback:0x000056339ac43730 @request_id="c72827d084ea4b88949d91dd2db4996e", @fawry_ref_number="970177",
#                                          @merchant_ref_number="9708f1cea8b5426cb57922df51b7f790", @customer_mobile="01004545545",
#                                          @customer_mail="fawry@fawry.com", @order_status="NEW", @order_amount=150.0, @fawry_fees=2.0, ...>

fawry_callback.fawry_ref_number # => 970177
fawry_callback.order_status # => NEW
```

## TODO:

- Add option to raise exception on request failure

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amrrbakry/fawry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
