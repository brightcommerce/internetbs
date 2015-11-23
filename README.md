[![Gem Version](https://badge.fury.io/rb/internetbs.svg)](https://badge.fury.io/rb/internetbs)

# InternetBS Client
The **InternetBS Client** is a Ruby API client for Internet.bs resellers. This client provides almost all of the functionality exposed by their API. To use this client you will need an API key.

## Background
The **InternetBS Client** is an opinionated client library for the Internet.bs API. We built this library to provide fully automated provisioning of domain names for our client's apps and websites using the Brightcommerce API.

The **InternetBS Client** provides endpoint access to the API methods that fulfill our requirements. Version 1 of our client is missing domain trade/transfer, domain forwarding and reseller account configuration. We will add domain related API endpoints in version 2.

The **InternetBS Client** has undergone extensive real-world testing with real domains. We have had difficulty testing some domain extensions as we don't have a presence in the countries that own those TLD's. We provide a list of domain extensions we have tested in the Testing section of this document.

## About Internet.bs
To find out more about Internet.bs please visit their [website](https://www.internetbs.net). You can find out more about the API by reading their [documentation](https://internetbs.net/ResellerRegistrarDomainNameAPI). To use their API you need to have a reseller account, you can find out more about their reseller requirements on their website.

## Installation
To install add the line to your `Gemfile`:
```
gem 'internetbs'
```
And call `bundle install`.

Alternatively, you can install it from the terminal:
```
gem install internetbs
```

## Dependencies
The **InternetBS Client** has the following runtime dependencies:
- Virtus ~> 1.0.3

## Compatibility
Developed with MRI 2.2, however the `.gemspec` only specifies MRI 2.0. It may work with other flavors, but it hasn't been tested. Please let us know if you encounter any issues.

## How To Use

### Prerequisites
The **InternetBS Client** requires an API key and password. By default the library will look for your API key and password in the environment variables `INTERNETBS_API_KEY` and `INTERNETBS_API_PWD`. The password is the same as used when logging into your account at their website.

### Environments
The **InternetBS Client** supports multiple environments. These environments don't have to match your application's environments. By default the environments provided by the client are `:production`, `:test` and `:development`. The default environment is `:production` and the credentials for this environment are read from ENV variables.

If you'd like to override this behavior and provide the API key and/or password directly to the client, setup a configuration initializer as shown below:
```ruby
InternetBS.configure do |config|
  config.credentials[:production][:api_key] = "B04B4E74C57C37DE4886"
  config.credentials[:production][:api_pwd] = "s3kr3t"
  config.credentials[:production][:api_uri] = "https://api.internet.bs"

  config.credentials[:test][:api_key] = "testapi"
  config.credentials[:test][:api_pwd] = "testpass"
  config.credentials[:test][:api_uri] = "https://testapi.internet.bs"
  
  config.credentials[:development][:api_key] = "testapi"
  config.credentials[:development][:api_pwd] = "testpass"
  config.credentials[:development][:api_uri] = "https://testapi.internet.bs"
end
```

Or pass the values directly to the attributes on the `InternetBS` namespace:
```ruby
# Set the environment to development:
InternetBS.environment = :development

# The set the credentials:
InternetBS.api_key = "B04B4E74C57C37DE4886"
InternetBS.api_pwd = "s3kr3t"
InternetBS.api_uri = "https://api.internet.bs"
```

The **InternetBS Client** provides flexibility by allowing you to use whatever credentials you want in whatever environment you want. You can, for instance, add a `:staging` environment if you want:
```ruby
InternetBS.credentials[:staging][:api_key] = "44CD64EEEFFF887755560B"
InternetBS.credentials[:staging][:api_pwd] = "another_pass"
InternetBS.credentials[:staging][:api_uri] = "https://api.internet.bs"
```

You can query the current environments also:
```ruby
InternetBS.environments #=> [:production, :test, :development, :staging]
```

And the current environment:
```ruby
InternetBS.environment #=> :development
```

### API Calls
The **InternetBS Client** provides access to the following Internet.bs API endpoints:

API Endpoint | Description
--- | ---
[Account/Balance/Get](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/08_account_related/01_account_balance_get) | The command is intended to retrieve the prepaid account balance.
[Account/Pricelist/Get](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/08_account_related/06_account_price_list_get) | The command is intended to obtain our pricelist.
[Domain/Check](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/01_domain_check) | The command is intended to check whether a domain is available for registration or not.
[Domain/Create](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/02_domain_create) | The command is intended to register a new domain.
[Domain/Update](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/03_domain_update) | The command is intended to update a domain.
[Domain/Renew](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/04_domain_renew) | The command is intended to renew a domain.
[Domain/Info](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/05_domain_info) | The command is intended to return full details about a domain name.
[Domain/List](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/06_domain_list) | This command is intended to retrieve a list of domains in your account.
[Domain/RegistryStatus](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/07_domain_registry_status) | The command is intended to view a domain registry status.
[Domain/Push](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/08_domain_push) | The command is intended to move a domain from one account to another.
[Domain/Count](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/01_domain_related/09_domain_count) | The command is intended to count total number of domains in the account.
[Domain/PrivateWhois/Enable](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/02_private_whois/01_domain_private_whois_enable) | The command is a purposely redundant auxiliary way to enable Private Whois for a specific domain.
[Domain/PrivateWhois/Disable](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/02_private_whois/02_domain_private_whois_disable) | The command is a purposely redundant auxiliary way to disable Private Whois for a specific domain.
[Domain/PrivateWhois/Status](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/02_private_whois/03_domain_private_whois_status) | The command is a purposely redundant auxiliary way to obtain the Private Whois status for a specific domain.
[Domain/RegistrarLock/Enable](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/03_registrar_lock/01_domain_registrar_lock_enable) | The command is a purposely redundant auxiliary way to enable the RegistrarLock for a specific domain.
[Domain/RegistrarLock/Disable](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/03_registrar_lock/02_domain_registrar_lock_disable) | The command is a purposely redundant auxiliary way to disable the RegistrarLock for a specific domain.
[Domain/RegistrarLock/Status](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/03_registrar_lock/03_domain_registrar_lock_status) | The command is a purposely redundant auxiliary way to retrieve the current RegistrarLock status for specific domain.
[Domain/DnsRecord/Add](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/05_dns_management_related/01_domain_dns_record_add) | The command is intended to add a new DNS record to a specific zone (domain).
[Domain/DnsRecord/Remove](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/05_dns_management_related/02_domain_dns_record_remove) | The command is intended to remove a DNS record from a specific zone.
[Domain/DnsRecord/Update](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/05_dns_management_related/03_domain_dns_record_update) | The command is intended to update an existing DNS record.
[Domain/DnsRecord/List](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/05_dns_management_related/04_domain_dns_record_list) | The command is intended to retrieve the list of DNS records for a specific domain.
[Domain/Host/Create](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/07_nameservers_related/01_domain_host_create) | The command is intended to create a host also known as name server or child host.
[Domain/Host/Update](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/07_nameservers_related/02_domain_host_update) | The command is intended to update a host; the command is replacing the current list of IP for the host with the new one you provide.
[Domain/Host/Info](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/07_nameservers_related/03_domain_host_info) | The command is intended to retrieve existing host (name server) information for a specific host.
[Domain/Host/Delete](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/07_nameservers_related/04_domain_host_delete) | The command is intended to delete (remove) an unwanted host.
[Domain/Host/List](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/07_nameservers_related/05_domain_host_list) | The command is intended to retrieve the list of hosts defined for a domain.

The **InternetBS Client** does not provide access to the following Internet.bs API endpoints. They are currently slated for Version 2:

API Endpoint | Description
--- | ---
[Domain/Transfer/Initiate](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/01_domain_transfer_initiate) | The command is intended to initiate an incoming domain name transfer.
[Domain/Transfer/Cancel](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/02_domain_transfer_cancel) | The command is intended to cancel a pending incoming transfer request.
[Domain/Transfer/ResendAuthEmail](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/03_domain_transfer_resend_auth_email) | The command is intended to resend the Initial Authorization for the Registrar Transfer email for a pending, incoming transfer request.
[Domain/TransferAway/Approve](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/04_domain_transfer_away_approve) | The command is intended to immediately approve a pending, outgoing transfer request (you are transferring a domain away).
[Domain/TransferAway/Reject](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/05_domain_transfer_away_reject) | The command is intended to reject a pending, outgoing transfer request (you are transferring away a domain).
[Domain/Transfer/History](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/06_domain_transfer_history) | The command is intended to retrieve the history of a transfer.
[Domain/Transfer/Retry](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/07_domain_transfer_retry) | This command is intended to reattempt a transfer in case an error occurred because inaccurate transfer auth info was provided or because the domain was locked or in some other cases where an intervention by the customer is required before retrying the transfer.
[Domain/Trade](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/08_domain_trade) | The command is used to initiate a .fr/.re/.pm/.yt/.tf/.wf trade.
[Domain/ChangeTag/DotUK](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/04_transfer_trade/09_domain_change_tag_uk) | The command is intended for transferring away a .uk domain.

The **InternetBS Client** *does not* provide access to the following Internet.bs API endpoints and not currently slated for inclusion since they not likely to be required by the Brightcommerce API. If there are significant requests for these endpoints to be included we'll consider adding them. If you would like to add them yourself, we'll be happy to accept merge requests as long as the coding style remains congruent. 

API Endpoint | Description
--- | ---
[Domain/EmailForward/Add](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/01_domain_email_forward_add) | The command is intended to add a new Email Forwarding rule.
[Domain/EmailForward/Remove](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/02_domain_email_forward_remove) | The command is intended to remove an existing Email Forwarding rule.
[Domain/EmailForward/Update](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/03_domain_email_forward_update) | The command is intended to update an existing Email Forwarding rule.
[Domain/EmailForward/List](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/04_domain_email_forward_list) | The command is intended to retrieve the list of email forwarding rules for a domain.
[Domain/UrlForward/Add](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/05_domain_url_forward_add) | The command is intended to add a new URL Forwarding rule.
[Domain/UrlForward/Remove](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/06_domain_url_forward_remove) | The command is intended to remove an existing URL Forwarding rule.
[Domain/UrlForward/Update](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/07_domain_url_forward_update) | The command is intended to update an existing URL Forwarding rule.
[Domain/UrlForward/List](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/06_forwarding_related/08_domain_url_forward_list) | The command is intended to retrieve the list of URL forwarding rules for a domain.
[Account/Configuration/Get](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/08_account_related/04_account_configuration_get) | The command is intended to view the account configuration.
[Account/Configuration/Set](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/08_account_related/05_account_configuration_set) | The command allows you to set the available configuration values for the API.
[Account/DefaultCurrency/Get](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/08_account_related/02_account_currency_get) | The command is intended to set the default currency.
[Account/DefaultCurrency/Set](https://internetbs.net/ResellerRegistrarDomainNameAPI/api/08_account_related/03_account_currency_set) | The command is intended to set the default currency.

## How To Use
We've attempted to make the **InternetBS Client** interface as consistent as possible. We send requests as follows to the Internet.bs API endpoints:
- All requests are `GET` or `POST` requests. The Internet.bs API doesn't accept `PATCH`, `PUT` or `DELETE` requests.
- Calling read-only endpoints use the `GET` HTTP verb and pass parameters as URL-endcoded.
- Calling endpoints that make changes, ie. create, update or delete requests, use the `POST` HTTP verb and send parameters as `x-www-form-urlencoded` in the request body.
- As specified by the Internet.bs API, only SSL-secured endpoints using the HTTPS protocol are called.
- The resellers API key and password are passed as parameters.
- The `responseformat` parameter requesting a JSON-encoded response is sent with every request.

The **InternetBS Client** breaks the API into consistent logical domain models. The models are backed by Virtus Model and most provide a `#fetch` method. Where a model performs a specific action the method will be named, and the parameters for the model must be provided as attributes on the class. Every call performs some validation before executing the API call. If the validation fails, the call will exit early, return `false` and any exceptions are made available in the `#errors` collection attribute.

Following are examples of how to instanciate each class with attributes where necessary, and the properties that can be queried on the class after each API call. All example information including names, addresses and other details are completely fictional and provided to give context.

### Account Balances
Fetch the current reseller account balances for each currency. Balances are returned as a collection of `AccountBalance`.
```ruby
@balances = InternetBS::AccountBalances.new

result = @balances.fetch #=> true

# Alternatively you pass the currency you're interested in:
@balances.currency = 'USD'
result = @balances.fetch #=> true

# If the fetch method fails it will return false 
# and populate the errors collection attribute:
unless result
  @balances.errors.each do |error|
    puts error
  end
end

# Iterate the collection of balances:
@balances.each do |balance|
  puts balance.amount   #=> 1234.56
  puts balance.currency #=> 'USD'
end
```

### Account Domains
Fetch a list of domains and domain counts for the currect reseller account. Domains are returned as a collection of `AccountDomain`.
```ruby
@domains = InternetBS::AccountDomains.new

result = @domains.fetch #=> true

# If the fetch method fails it will return false 
# and populate the errors collection attribute:
if result == false
  @account.errors.each do |error|
    puts error
  end
end

# Iterate the collection of domains:
@domains.list.each do |domain|
  puts domain.name #=> 'example.com'
end
```

#### Options
To customize the results returned you can set the following options as attributes on the class:

Option | Class | Description
--- | --- | ---
`#compact_list` | Boolean | If `true` the list of domains returned will consist solely of domain names, if `false` the list of domains returned will contain additional information such as expiration date, epp auth info, status and registrar lock status. The default value is `true`.
`#expiring_only` | Boolean | If `true` will restrict list of domains returned to those that are expiring. This cannot be used in conjunction with `#pending_transfer_only`. The default value is `false`.
`#extension_filter` | String | A comma-separated list of domain extensions e.g. `com,net,org,co.uk`.
`#pending_transfer_only` | Boolean | If `true` will restrict list of domains returned to those that are in Pending Transfer status.
`#range_from`, `#range_to` | Integer | If you want the listing to be paginated use these two parameters, they represent page numbers.
`#search_term_filter` | String | Retrieve a list of domains that contain a specific text.
`#sort_by` | String | specify a sorting criteria. Possible values are: `DOMAIN_NAME`, `DOMAIN_NAME_DESC`, `EXPIRATION`, `EXPIRATION_DESC`. The default value is `DOMAIN_NAME`.

#### Retrieving Totals
To retrieve the number of domains in an account, the **InternetBS Client** provides the following method:

Method | Description
--- | ---
`#totals` | Call this method to retrieve the total number of domains. The number of domains can be queried on the `#total_domains` attribute. The total of number for each TLD can be queried on the `#total_domains_by_tld` attribute.

### Account Prices
Fetch the price list for the current reseller. Prices are returned as a collection of `AccountPrice`.
```ruby
@prices = InternetBS::AccountPrices.new

result = @prices.fetch #=> true

# If the fetch method fails it will return false 
# and populate the errors collection attribute:
if result == false
  @prices.errors.each do |error|
    puts error
  end
end

@prices.list #=> an enumerable array of InternetBS::AccountPrice
@prices.list.size #=> 39

# Enumerate each
@prices.list.each do |price|
  puts price.name
  ...
end

# AccountPrice properties
price = @prices.list.select { |p| 
          p.name == '.com' && p.operation == 'registration'
        }
price.is_a?(InternetBS::AccountPrice) #=> true
price.currency #=> USD
price.name #=> .com
price.operation #=> registration
price.price_1_year #=> 8.99
price.price_2_years #=> 8.95
price.price_3_years #=> 8.93
price.price_4_years #=> 8.91
price.price_5_years #=> 8.89
price.price_6_years #=> 8.87
price.price_7_years #=> 8.85
price.price_8_years #=> 8.83
price.price_9_years #=> 8.81
price.price_10_years #=> 8.79

# Display the price level (only available from version 2 query):
@prices.level #=> Basic
```

#### Options
The following options are available as attributes on the `AccountPrices` class. Set these attributes before calling `#fetch`.

Option | Class | Description
--- | --- | ---
`#version` | Integer | Pass `1` or `2` for the version attribute to fetch prices. Version 1 will retrieve prices for one year. Version 2 will retrieve prices for 10 years.
`#currency` | String | Retrieve the price list in a specific currency. By default the list will be retrieved in `USD`.
`#discount_code` | String | Apply a discount to the retrieved price list.

### Domain Availability
Check whether a domain is available for registration or not.
```ruby
@domain = InternetBS::DomainAvailability.new(:domain => 'acme.com')

result = @domain.fetch #=> true

# If the fetch method fails it will return false 
# and populate the errors collection attribute:
unless result
  @domain.errors.each do |error|
    puts error
  end
end

# Is the domain available?
puts @domain.status #=> true

# Other properties you can check:
puts @domain.transaction_id #=> 234678268342423876
puts @domain.max_registration_period #=> 10 # years
puts @domain.min_registration_period #=> 1 # year
puts @domain.private_whois_allowed #=> true
puts @domain.realtime_registration #=> true
puts @domain.registrar_lock_allowed #=> true
```

### Domain Information
Check whether a domain is available for registration or not.
```ruby
@domain = InternetBS::DomainInformation.new(:domain => 'acme.com')

result = @domain.fetch #=> true

# If the fetch method fails it will return false 
# and populate the errors collection attribute:
unless result
  @domain.errors.each do |error|
    puts error
  end
end

# DomainInformation properties:
puts @domain.domain_status #=> REGISTERED
puts @domain.auto_renew #=> false
puts @domain.domain_extension #=> .com
puts @domain.expiration_date #=> 2011/03/05
puts @domain.private_whois #=> FULL
puts @domain.registrar_lock #=> ENABLED
puts @domain.transfer_auth_info #=> 1542c06388d8e03e14613788ca6bd914
puts @domain.contacts #=> array of DomainContact, see below
```

#### Domain Contacts
```ruby
# Iterate domain contacts:
@domain.contacts.each do |contact|
  puts contact.contact_type #=> :registrant
  puts contact.city
  puts contact.country
  puts contact.country_code
  puts contact.email
  puts contact.fax
  puts contact.first_name
  puts contact.last_name
  puts contact.obfuscate_email #=> true
  puts contact.organization
  puts contact.phone_number
  puts contact.postal_code
  puts contact.street
  puts contact.street_2
  puts contact.street_3
  puts contact.additional_attributes # see below
end
```

#### Domain Contact Additional Attributes
Some domain extensions have additional attributes. Listed below are the additional attributes for each domain extension.

##### .ASIA TLD
CED is an acronym for Charter Eligibility Declaration.

Attribute | Type | Required?
--- | --- | ---
ced_locality | String | YES
ced_entity | String (only `CED_ENTITY_TYPES`) | YES
ced_entity_other | String | YES if `ced_entity == 'other'`
ced_id_form | String (only `CED_ID_FORM_TYPES`) | YES
ced_id_form_other | String | YES if `ced_id_form == 'other'`
ced_city | String | NO
ced_id_number | String | NO
ced_state_province | String | NO

##### .DE TLD
Attribute | Type | Required?
--- | --- | ---
role | String (only `ROLES`) | YES
ip_address | String | YES
disclose_name | Boolean (default `false`) | YES
disclose_contact | Boolean (default `false`) | YES
disclose_address | Boolean (default `false`) | YES
remark | String | NO
sip_uri | String | NO
terms_accepted | Boolean (default `false`) | YES

##### .EU TLD
Attribute | Type | Required?
--- | --- | ---
language | String (only `LANGUAGE_CODES`) | YES

##### .FR TLD
Attribute | Type | Required?
--- | --- | ---
entity_type | String (only `CONTACT_ENTITY_TYPES`) | YES
entity_name | String | YES if `entity_type == COMPANY,TRADEMARK,ASSOCIATION,ENTITY`
entity_vat | String | NO
entity_siren | String | NO
entity_duns | String | NO
entity_trade_mark | String | YES if `entity_type == TRADEMARK`
entity_waldec | String | YES if `entity_type == ASSOCIATION`
entity_date_of_association | Date (`YYYY-MM-DD`) | YES if `entity_type == ASSOCIATION`
entity_date_of_publication | Date (`YYYY-MM-DD`) | YES if `entity_type == ASSOCIATION`
entity_gazette_announcement_number | String | YES if `entity_type == ASSOCIATION`
entity_gazette_page_number | String | YES if `entity_type == ASSOCIATION`
entity_birth_date | Date (`YYYY-MM-DD`) | NO
entity_birth_place_country_code | String (only `COUNTRY_CODES`) | NO
entity_birth_city | String | NO
entity_birth_place_postal_code | String | NO
entity_restricted_publication | Boolean | NO
other_contact_entity | String | 

##### .IT TLD
Attribute | Type | Required?
--- | --- | ---
entity_type | String (only `ENTITY_TYPES`) | YES
nationality | String (only `COUNTRY_CODES`) | YES
reg_code | String | YES
hide_whois | Boolean (default `false`) | YES
province | String (only `PROVINCIAL_CODES` | YES if `nationality == IT`
terms_1_accepted | Boolean (default `false`) | YES
terms_2_accepted | Boolean (default `false`) | YES
terms_3_accepted | Boolean (default `false`) | YES
terms_4_accepted | Boolean (default `false`) | YES
ip_address | String | YES

##### .NL TLD
Attribute | Type | Required?
--- | --- | ---
ip_address | String | YES
legal_form | String (only `LEGAL_FORMS`) | YES
registration_number | String | NO
terms_accepted | Boolean (default `false`) | YES

##### .UK TLD
Attribute | Type | Required?
--- | --- | ---
county | String | YES
organization_type | String (only `ORGANIZATION_TYPES`) | YES
organization_number | String |  YES if `organization_type == LTD,PLC,LLP,IP,SCH,RCHAR`
registration_number | String | YES if `organization_type == LTD,PLC,LLP,IP,SCH,RCHAR`
opt_out | Boolean (default `false`) | YES if `organization_type == FIND,IND`

##### .US TLD
Attribute | Type | Required?
--- | --- | ---
purpose | String (only `PURPOSES`) | YES
nexus_category | String (only `NEXUS_CATEGORIES`) | YES
nexus_country | String (only `COUNTRY_CODES`) | YES if `nexus_category == C31,C32`

### Domain Hosts (Name Servers)
Add, update, remove and list domain host records, otherwise known as name servers or child hosts.
```ruby
@ns = InternetBS::DomainHosts.new(:domain => 'acme.com')

# TODO: Document `:compact => false` # default is true

result = @ns.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
if result == false
  @ns.errors.each do |err|
    puts err
  end
end

@ns.list #=> an array of DomainHost
@ns.list.size #=> 3

# Enumerate each
@ns.list.each do |ns|
  puts ns.host
end

# DomainHost properties
ns = @ns.list.first
ns.is_a?(DomainHost) #=> true
puts ns.host #=> ns1.someregistrar.com
puts ns.ip_addresses #> [111.222.333.444]

# Add a domain host (pass in a DomainHost instance):
ns4 = InternetBS::DomainHost.new(
  :host => "ns4.acme.com", 
  :ip_addresses => ['112.223.334.445'] # array of one or more ip addresses
)

@hosts = DomainHosts.new(:domain => 'acme.com')
result = @hosts.add(ns4) #=> true

# Update a domain host (pass in a DomainHost instance):
ns4.ip_addresses[0] = '112.223.334.455'
result = @hosts.update(ns4) #=> true

# Remove a domain host (pass in a DomainHost instance):
result = @hosts.remove(ns4) #=> true
```

### Domain Records (DNS)
Add, update, remove and list domain records, otherwise known as DNS records.
```ruby
@dns_records = InternetBS::DomainRecords.new(:domain => 'acme.com')

# TODO: Document `:filter_type => DomainRecord::TYPES` # 'A', 'AAAA', 'DYNAMIC', 'CNAME', 'MX', 'SRV', 'TXT', 'NS'

result = @dns_records.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
if result == false
  @dns_records.errors.each do |err|
    puts err
  end
end

@dns_records.list #=> an array of DomainRecord
@dns_records.list.size #=> 8

# Enumerate each
@dns_records.list.each do |record|
  puts record.name #=> www.acme.com
end

# DomainRecord properties
dns = @dns_records.list.first
dns.is_a?(DomainRecord) #=> true
puts dns.type #=> A
puts dns.value #=> 111.222.333.444
puts dns.ttl #=> 3600

# Add a domain record (pass in a DomainRecord instance):
dns_record = InternetBS::DomainRecord.new(
  :name => "api.acme.com", 
  :type => "A",
  :value => "111.222.333.456",
  :ttl => 3600
)

@dns_records = DomainRecords.new(:domain => 'acme.com')
result = @dns_records.add(dns_record) #=> true

# Update a domain record (pass in a Domainrecord instance):
dns_record.value = '111.222.333.457'
result = @dns_records.update(dns_record) #=> true

# Remove a domain record (pass in a DomainRecord instance):
result = @dns_records.remove(dns_record) #=> true
```

### Private Whois
This API is intended for checking and/or changing the private whois option for a domain.
```ruby
@private_whois = InternetBS::PrivateWhois.new(:domain => "acme.com")

result = @private_whois.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
if result == false
  @private_whois.errors.each do |err|
    puts err
  end
end

@private_whois.privacy_status #=> FULL

# Disable privacy:
result = @private_whois.disable #=> true

# Enable privacy:
@private_whois.privacy_status = 'PARTIAL'
result = @private_whois.enable #=> true
```

### Registrar Lock
This API is intended for checking and/or changing the registrar lock for a domain.
```ruby
@registrar_lock = InternetBS::RegistrarLock.new(:domain => "acme.com")

result = @registrar_lock.fetch #=> true

# If the fetch method fails it will return false and populate the errors collection attribute:
if result == false
  @registrar_lock.errors.each do |err|
    puts err
  end
end

@registrar_lock.lock_status #=> FULL

# Disable registrar lock:
result = @registrar_lock.disable #=> true

# Enable registrar lock:
result = @registrar_lock.enable #=> true
```

### Registry Status
This API is intended for checking the registry status of a domain.
```ruby
@registry_status = InternetBS::RegistryStatus.new(:domain => "acme.com")

result = @registry_status.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
if result == false
  @registry_status.errors.each do |err|
    puts err
  end
end

@registry_status.registry_status #=> clientTransferProhibited
```

### Updating a Domain
Update the properties of a domain including auto-renewal, private whois, registrar lock, transfer auth info, domain contacts, and nameservers. For .tel domains you can also update the hosting account and password.
```ruby
@domain = InternetBS::UpdateDomain.new(:domain => "acme.com")

result = @domain.fetch #=> true

# If the fetch method fails it will return false
# and populate the errors collection attribute:
if result == false
  @domain.errors.each do |err|
    puts err
  end
end

# Set properties that need updating on the `@domain` instance:
@domain.auto_renew = false
@domain.private_whois = 'FULL'
@domain.registrar_lock = 'ENABLED'
@domain.transfer_auth_info

registrant = InternetBS::DomainContact.new(
  :contact_type => :registrant,
  :first_name => 'John',
  :last_name => 'Doe',
  ...
)
@domain.contacts = [registrant, billing, technical, admin]

ns_list = ['ns1.example.com', 'ns2.example.com', 'ns3.example.com']
@domain.nameservers = ns_list

# For .tel domains only:
@domain.tel_hosting_account = 'my_username'
@domain.tel_hosting_password = 'my_password'
@domain.tel_hide_whois_data = true

# Then call the `#update!` method:
result = @domain.update! #=> true
```

### Ordering a Domain
Use this class to purchase a domain. Contacts must be provided as an array of `DomainContact` records.
```ruby
@order = InternetBS::OrderDomain.new(
  :domain               => "bigacme.com",
  :currency             => "USD",
  :period               => "1Y",
  :nameservers          => ['ns1.example.com', 'ns2.example.com'],
  :transfer_auth_info   => 'EPP AUTH INFO HERE', # optional
  :registrar_lock       => 'ENABLED', #optional
  :private_whois        => 'FULL', # optional
  :discount_code        => '10PERCENT', # optional
  :auto_renew           => true, # optional
  :contacts             => [registrant, admin, billing, ...],
  :tel_hosting_account  => 'my_username', # optional, .tel only
  :tel_hosting_password => 'my_password', # optional, .tel only
  :tel_hide_whois_data  => true # optional, .tel only
)

result = @order.purchase! #=> true

# If the purchase! method fails it will return false
# and populate the errors collection attribute:
if result == false
  @order.errors.each do |err|
    puts err
  end
end

# Order properties
@order.status #=> 'SUCCESS'
@order.transaction_id #=> 820b6791e386b31b354e613a6371c7bc
@order.total_price #=> 13.9
```

### Renewing a Domain
Use this class to renew a domain. Currency will default to `USD` and the period will default to one year (`1Y`).
```ruby
@renewal = InternetBS::RenewDomain.new(
  :domain               => "bigacme.com",
  :currency             => "USD", # default
  :period               => "1Y", # default
  :discount_code        => '10PERCENT' # optional
)

result = @renewal.purchase! #=> true

# If the purchase! method fails it will return false
# and populate the errors collection attribute:
if result == false
  @renewal.errors.each do |err|
    puts err
  end
end

# Renewal properties
@renewal.status #=> 'SUCCESS'
@renewal.transaction_id #=> 4e74069f2b5d1d62282c21d0a2e49a27
@renewal.total_price #=> 13.9
```

### Country Codes
The **InternetBS Client** provides a constant hash of country codes. This list is derived from https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2. The hash keys are ISO_3166-1_alpha-2 codes and the values are the country display name. The top 20 countries by number of Internet users are grouped first, see  https://en.wikipedia.org/wiki/List_of_countries_by_number_of_Internet_users.

Example: access a country name by code:
```ruby
InternetBS::COUNTRY_CODES['US'] #=> United States
```
All the regular hash functions are available for finding keys and values, but the hash is immutable. If you want to manipulate the list, for example to sort it differently; you will have to copy it into a new hash variable first.

### Language Codes
The **InternetBS Client** provides a constant hash of the most commonly required language codes. This list is derived from https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes. The hash keys are ISO 639-1 two-letter codes, and the values are the language display name.

Example: access a language name by code:
```ruby
InternetBS::LANGUAGE_CODES['en'] #=> English
```
All the regular hash functions are available for finding keys and values, but the hash is immutable. If you want to manipulate the list, for example to sort it differently; you will have to copy it into a new hash variable first.

## Testing
TBA - Currently partially tested using reseller account and testapi endpoints.

## To Do
- Investigate account transactions API endpoint.
- Implement Version 2 API endpoints.
- Test suite with mocks for CI/CD scenarios.

## Acknowledgements
#### Version 1.0.0
- Jurgen Jocubeit - President & CEO, [Brightcommerce, Inc.](https://twitter.com/brightcommerce)

## License
This library is release in the public domain under the [MIT License](http://opensource.org/licenses/MIT).

## Copyright
Copyright 2015 Brightcommerce, Inc.
All rights reserved.
