module InternetBS
  class UpdateDomain < Base
    attribute :auto_renew,           Boolean              # YES or NO
    attribute :contacts,             Array[DomainContact]
    attribute :domain,               String
    attribute :domain_extension,     String 
    attribute :nameservers,          Array[String]
    attribute :private_whois,        String               # DISABLED or FULL or PARTIAL
    attribute :registrar_lock,       String               # ENABLED or DISABLED or NOTADMITTED
    attribute :tel_hosting_account,  String               # .tel domains only
    attribute :tel_hosting_password, String               # .tel domains only
    attribute :tel_hide_whois_data,  Boolean              # .tel domains only, either YES or NO
    attribute :transfer_auth_info,   String
    
    def update!
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      @domain_extension = @domain.split('.').last
      
      params = {'domain' => @domain}
      
      params.merge!({'transferauthinfo' => @transfer_auth_info}) if @transfer_auth_info
      parmas.merge!({'registrarlock' => @registrar_lock}) if @registrar_lock
      params.merge!({'privatewhois' => @private_whois}) if @private_whois
      params.merge!({'autorenew' => @auto_renew ? 'YES' : 'NO'}) if @auto_renew
      
      if @nameservers.any?
        params.merge!({'ns_list' => @nameservers.join(',')})
      end
      
      if @contacts.any?
        @contacts.each do |contact|
          contact.domain_extension = @domain_extension
          params.merge!(contact.params)
        end
      end
      
      if @domain_extension == "tel"
        params.merge!({'telhostingaccount' => @tel_hosting_account}) if @tel_hosting_account
        params.merge!({'telhostingpassword' => @tel_hosting_password}) if @tel_hosting_password
        params.merge!({'telhidewhoisdata' => @tel_hide_whois_data ? 'YES' : 'NO'}) if @tel_hide_whois_data
      end
      
      response = Client.post('/domain/update', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        if @status == 'SUCCESS'
          
          debugger
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
