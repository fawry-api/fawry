# Fawry
A plug-and-play library that makes interfacing with Fawry's payment gateway API a breeze:
- [Charge customers](https://github.com/fawry-api/fawry#charge-customers)
- [Refund customers](https://github.com/fawry-api/fawry#refund-customers)
- [Get payment status](https://github.com/fawry-api/fawry#get-payment-status)
- Parse Fawry's service callback V2 _(Not yet implemented)_

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
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amrrbakry/fawry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fawry project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/amrrbakry/fawry/blob/master/CODE_OF_CONDUCT.md).
