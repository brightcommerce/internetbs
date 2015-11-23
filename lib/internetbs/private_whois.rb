module InternetBS
  class PrivateWhois < Base
    attribute :domain,         String
    attribute :privacy_status, String # FULL or PARTIAL or DISABLED or FAILURE
    
    def disable
      set_private_whois_status :disable
    end
    
    def enable
      set_private_whois_status :enable
    end
    
    def fetch
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      response = Client.get('/domain/privatewhois/status', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        if @status == 'SUCCESS'
          @privacy_status = hash['privatewhoisstatus']
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
    
    private
    
    # Expects an action of either :enable or :disable.
    def set_private_whois_status(action)
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      
      if action == 'enable' && @privacy_status
        optional_params = {'type' => @privacy_status}
        params.merge!(optional_params)
      end
      
      response = Client.post("/domain/privatewhois/#{action.to_s}", params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        if @status == 'SUCCESS'
          @privacy_status = hash['privatewhoisstatus']
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
