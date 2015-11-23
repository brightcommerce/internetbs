module InternetBS
  class DomainAvailability < Base
    attribute :domain,                 String
    attribute :max_reg_period,         String
    attribute :min_reg_period,         String
    attribute :private_whois_allowed,  Boolean
    attribute :realtime_registration,  Boolean
    attribute :registrar_lock_allowed, Boolean
    
    def fetch
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      response = Client.get('/domain/check', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)
        
        @status = hash['status']
        @transaction_id = hash['transactid']
        @max_registration_period = hash['maxregperiod']
        @min_registration_period = hash['minregperiod']
        @private_whois_allowed   = hash['privatewhoisallowed']  == 'YES' ? true : false
        @realtime_registration   = hash['realtimeregistration'] == 'YES' ? true : false
        @registrar_lock_allowed  = hash['registrarlockallowed'] == 'YES' ? true : false
        
        return true
      else
        set_errors(response)
        return false
      end
    end
  end
end
