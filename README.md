[![CircleCI](https://circleci.com/gh/fawry-api/fawry.svg?style=svg)](https://circleci.com/gh/fawry-api/fawry)

# Fawry

**Disclaimer:** we are _not officially affilated_ with the _Fawry_ company.

A plug-and-play library that makes interfacing with Fawry's payment gateway API a breeze:

- [Charge customers](https://github.com/fawry-api/fawry#charge-customers)
- [Refund customers](https://github.com/fawry-api/fawry#refund-customers)
- [Get payment status](https://github.com/fawry-api/fawry#get-payment-status)
- [Parse Fawry's service callback V2](https://github.com/fawry-api/fawry#parse-fawry-service-callback-v2)
- [Configuration keys as environment variables](https://github.com/fawry-api/fawry#configuration-keys-as-environment-variables)

_Fawry's production and sandbox environments are supported._

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fawry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fawry

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

# use sandbox option to call Fawry's sandbox env
res = Fawry.charge(params, sandbox: true)
#  => #<Fawry::FawryResponse:0x0000564257d0ea90 @type="ChargeResponse", @reference_number="931600239",
#                                               @merchant_ref_number="io5jxf3jp27kfh8m719arcqgw7izo7db",
#                                               @expiration_time=1573153206979, @status_code=200,
#                                               @status_description="Operation done successfully">

res.success? # => true
res.reference_number # => 931600239
```

###  Refund Customers

```ruby
params = { "merchant_code": 'merchant_code',
           "reference_number": '931337410',
           "refund_amount": 20,
           "fawry_secure_key": 'fawry_secure_key' }

res = Fawry.refund(params, sandbox: true)
#  => #<Fawry::FawryResponse:0x0000564257d0ea90 @type="ResponseDataModel", @status_code=200,
#                                               @status_description="Operation done successfully">

res.success? # => true
```

###  Get Payment Status

```ruby
params = { "merchant_code": 'merchant_code',
           "merchant_ref_number": 'ssshxb98phmyvm434es62kage3nsm2cj',
           "fawry_secure_key": 'fawry_secure_key' }

res = Fawry.payment_status(params, sandbox: true)
 # => #<Fawry::FawryResponse:0x0000559974056898 @type="PaymentStatusResponse", @reference_number="931922417",
 #                                              @merchant_ref_number="ssshxb98phmyvm434es62kage3nsm2cj",
 #                                              @expiration_time=1573297736167, @status_code=200,
 #                                              @status_description="Operation done successfully", @payment_amount=20,
 #                                              @payment_method="PAYATFAWRY", @payment_status="UNPAID">

res.success? # => true
res.payment_status # => UNPAID
```

###  Parse Fawry service callback v2

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

# FAWRY_SECURE_KEY env var must be set
fawry_callback = Fawry.parse_callback(callback_params, {})
# <Fawry::FawryCallback:0x000056339ac43730 @request_id="c72827d084ea4b88949d91dd2db4996e", @fawry_ref_number="970177",
#                                          @merchant_ref_number="9708f1cea8b5426cb57922df51b7f790", @customer_mobile="01004545545",
#                                          @customer_mail="fawry@fawry.com", @order_status="NEW", @order_amount=150.0, @fawry_fees=2.0, ...>

fawry_callback.fawry_ref_number # => 970177
fawry_callback.order_status # => NEW
```

### Configuration keys as environment variables

Fawry configuration keys such as merchant code and secure key can be sent with the params (`merchant_code`, `fawry_secure_key` ) to the **charge**, **refund**, **payment_status** methods, _or_ they can be set as environment variables: (`FAWRY_MERCHANT_CODE`, `FAWRY_SECURE_KEY`).

To **parse** fawry callback, you _must_ set the env var `FAWRY_SECURE_KEY`.

## TODO:
- Translate README to Arabic
- Add public API documentation to README
- Add option to raise exception on request failure

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amrrbakry/fawry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
