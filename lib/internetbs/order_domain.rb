module InternetBS
  class OrderDomain < Base
    attribute :auto_renew,           Boolean                   # YES or NO
    attribute :contacts,             Array[DomainContact]
    attribute :currency,             String, :default => 'USD'
    attribute :discount_code,        String 
    attribute :domain,               String
    attribute :domain_extension,     String 
    attribute :nameservers,          Array[String]
    attribute :period,               String                    # 1Y, 2Y up to 10Y
    attribute :private_whois,        String                    # DISABLED or FULL or PARTIAL
    attribute :registrar_lock,       String                    # ENABLED or DISABLED or NOTADMITTED
    attribute :tel_hosting_account,  String                    # .tel domains only
    attribute :tel_hosting_password, String                    # .tel domains only
    attribute :tel_hide_whois_data,  Boolean                   # .tel domains only, either YES or NO
    attribute :total_price,          Float
    attribute :transfer_auth_info,   String
    
    def purchase!
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      @domain_extension = @domain.split('.').last
      
      params = {
        'domain'   => @domain, 
        'currency' => @currency,
        'period'   => @period,
        'ns_list'  => @nameservers.join(',')
      }
      
      params.merge!({'transferauthinfo' => @transfer_auth_info}) if @transfer_auth_info
      parmas.merge!({'registrarlock' => @registrar_lock}) if @registrar_lock
      params.merge!({'privatewhois' => @private_whois}) if @private_whois
      params.merge!({'discountcode' => @discount_code}) if @discount_code
      params.merge!({'autorenew' => @auto_renew ? 'YES' : 'NO'}) if @auto_renew
      
      @contacts.each do |contact|
        params.merge!(contact.params)
      end

      if @domain_extension == "tel"
        params.merge!({
          'telhostingaccount' => @tel_hosting_account,
          'telhostingpassword' => @tel_hosting_password
        })
        if @tel_hide_whois_data
          params.merge!({'telhidewhoisdata' => @tel_hide_whois_data ? 'YES' : 'NO'})
        end
      end
      
      response = Client.post('/domain/create', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        if @status == 'SUCCESS'
          @currency    = hash['currency']
          @total_price = hash['price']
        else
          set_errors(response)
          return false
        end
                
        return true
      else
        set_errors(response)
        return false
      end
    end
    
  end
end
