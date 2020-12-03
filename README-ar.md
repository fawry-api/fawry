[![CircleCI](https://circleci.com/gh/fawry-api/fawry.svg?style=svg)](https://circleci.com/gh/fawry-api/fawry)

# Fawry

**تنويه:** نحن لسنا تابعين رسميًا لشركة فوري.

مكتبة لتسهيل التعامل مع خدمات الدفع الخاصة بشبكة الدفع الإلكتروني فوري:

- [لإجراء عملية دفع](https://github.com/fawry-api/fawry#charge-customers)
- [لإجراء عملية استرداد](https://github.com/fawry-api/fawry#refund-customers)
- [حالة الدفع](https://github.com/fawry-api/fawry#get-payment-status)
- [تحليل رد خدمة فوري V2](https://github.com/fawry-api/fawry#parse-fawry-service-callback-v2)
- [طلب البيانات الخاصة بإعدادات الإستخدام](https://github.com/fawry-api/fawry#configuration-keys-as-environment-variables)

_المكتبة تدعم النظام التجريبي لفوري ايضا_

## لإضافة وتشغيل المكتبة

أضف هذا السطر إلى ملف Gemfile الخاص بتطبيقك:

```ruby
gem 'fawry'
```

ثم نفذ:

    $ bundle

أو قم بتثبيته بنفسك على النحو التالي:

    $ gem install fawry

## طريقة الإستعمال

### لإجراء عملية دفع

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

# استخدم خيار النظام التجريبي للاتصال بالنظام التجريبي الخاص بفوري
# sandbox: true
res = Fawry.charge(params, sandbox: true)
#  => #<Fawry::FawryResponse:0x0000564257d0ea90 @type="ChargeResponse", @reference_number="931600239",
#                                               @merchant_ref_number="io5jxf3jp27kfh8m719arcqgw7izo7db",
#                                               @expiration_time=1573153206979, @status_code=200,
#                                               @status_description="Operation done successfully">

res.success? # => true
res.reference_number # => 931600239
```

### لإجراء عملية استرداد

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

### حالة الدفع

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

### رد اتصال خدمة تحليل فوري v2

```ruby
# تم إرسال المعلمات من خادم فوري
callback_params = { "requestId": 'c72827d084ea4b88949d91dd2db4996e', "fawryRefNumber": '970177',
                    "merchantRefNumber": '9708f1cea8b5426cb57922df51b7f790',
                    "customerMobile": '01004545545', "customerMail": 'fawry@fawry.com',
                    "paymentAmount": 152.00, "orderAmount": 150.00, "fawryFees": 2.00,
                    "shippingFees": '', "orderStatus": 'NEW', "paymentMethod": 'PAYATFAWRY',
                    "messageSignature": 'b0175565323e464b01dc9407160368af5568196997fb6e379374a4f4fbbcf587',
                    "orderExpiryDate": 1_533_554_719_314,
                    "orderItems": [{ "itemCode": 'e6aacbd5a498487ab1a10ae71061535d', "price": 150.0, "quantity": 1 }] }

# FAWRY_SECURE_KEY يجب تعيين متغير البيئة
fawry_callback = Fawry.parse_callback(callback_params, {})
# <Fawry::FawryCallback:0x000056339ac43730 @request_id="c72827d084ea4b88949d91dd2db4996e", @fawry_ref_number="970177",
#                                          @merchant_ref_number="9708f1cea8b5426cb57922df51b7f790", @customer_mobile="01004545545",
#                                          @customer_mail="fawry@fawry.com", @order_status="NEW", @order_amount=150.0, @fawry_fees=2.0, ...>

fawry_callback.fawry_ref_number # => 970177
fawry_callback.order_status # => NEW
```

### طلب البيانات الخاصة بإعدادات الإستخدام

يمكن إرسال بيانات تهيئة فوري مثل رمز التاجر ومفتاح الأمان خلال البيانات المعطاه (`merchant_code`, `fawry_secure_key` ) الى **charge**, **refund**, **payment_status** طرق, _أو_ يمكن تعيينها كمتغيرات لنظام التشغيل: (`FAWRY_MERCHANT_CODE`, `FAWRY_SECURE_KEY`).

لتحليل fawry معاودة الاتصال ، يجب عليك ضبط متغير البيئة `FAWRY_SECURE_KEY`.

## الخطوات القادمة المطلوب تنفيذها:
- إضافة خيار لرفع الاستثناء عند فشل الطلب

## تطوير المكتبة

بعد التحقق من الريبو ، قم بتشغيل `bin/setup` لتثبيت التبعيات.
ثم نفذ الأمر `rake spec` لإجراء الاختبارات. يمكنك أيضا الجري `bin/console` للمطالبة التفاعلية التي تسمح لك بالتجربة.

لتثبيت هذه المكتبة على جهازك ، قم بتشغيل `bundle exec rake install`. لإصدار إصدار جديد ، قم بتحديث رقم الإصدار بتنسيق `version.rb`, ثم نفذ الأمر `bundle exec rake release`, الذي سينشئ علامة git للإصدار ، ويدفع التزامات git والعلامات ، ويدفع ملف `.gem` يا صديق [rubygems.org](https://rubygems.org).

## المساهمة

يتم الترحيب بتقارير الأخطاء وطلبات السحب على GitHub في https://github.com/amrrbakry/fawry. يهدف هذا المشروع إلى أن يكون مساحة آمنة ومرحبة للتعاون ، ومن المتوقع أن يلتزم المساهمون بـ [Contributor Covenant](http://contributor-covenant.org) القواعد السلوكية.
