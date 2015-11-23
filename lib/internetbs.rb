module InternetBS
  autoload :AccountBalance,      'internetbs/account_balance'
  autoload :AccountBalances,     'internetbs/account_balances'
  autoload :AccountDomain,       'internetbs/account_domain'
  autoload :AccountDomains,      'internetbs/account_domains'
  autoload :AccountPrice,        'internetbs/account_price'
  autoload :AccountPrices,       'internetbs/account_prices'
  autoload :AccountTransaction,  'internetbs/account_transaction'
  autoload :AccountTransactions, 'internetbs/account_transactions'
  autoload :Base,                'internetbs/base'
  autoload :Client,              'internetbs/client'
  autoload :Configuration,       'internetbs/configuration'
  autoload :DomainAvailability,  'internetbs/domain_availability'
  autoload :DomainContact,       'internetbs/domain_contact'
  autoload :DomainHost,          'internetbs/domain_host'
  autoload :DomainHosts,         'internetbs/domain_hosts'
  autoload :DomainInformation,   'internetbs/domain_information'
  autoload :DomainPush,          'internetbs/domain_push'
  autoload :DomainRecord,        'internetbs/domain_record'
  autoload :DomainRecords,       'internetbs/domain_records'
  autoload :DomainTotal,         'internetbs/domain_total'
  autoload :DotAsiaAttributes,   'internetbs/dot_asia_attributes'
  autoload :DotDEAttributes,     'internetbs/dot_de_attributes'
  autoload :DotEUAttributes,     'internetbs/dot_eu_attributes'
  autoload :DotFRAttributes,     'internetbs/dot_fr_attributes'
  autoload :DotITAttributes,     'internetbs/dot_it_attributes'
  autoload :DotNLAttributes,     'internetbs/dot_nl_attributes'
  autoload :DotUKAttributes,     'internetbs/dot_uk_attributes'
  autoload :DotUSAttributes,     'internetbs/dot_us_attributes'
  autoload :OrderDomain,         'internetbs/order_domain'
  autoload :PrivateWhois,        'internetbs/private_whois'
  autoload :RegistrarLock,       'internetbs/registrar_lock'
  autoload :RegistryStatus,      'internetbs/registry_status'
  autoload :RenewDomain,         'internetbs/renew_domain'
  autoload :UpdateDomain,        'internetbs/update_domain'

  @@configuration = nil
  
  def self.configure
    @@configuration = Configuration.new
    yield(configuration) if block_given?
    configuration
  end

  def self.configuration
    @@configuration || configure
  end
  
  def self.method_missing(method_sym, *arguments, &block)
    if configuration.respond_to?(method_sym)
      configuration.send(method_sym)
    else
      super
    end
  end

  def self.respond_to?(method_sym, include_private = false)
    if configuration.respond_to?(method_sym, include_private)
      true
    else
      super
    end    
  end
end
