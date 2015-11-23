module InternetBS
  class RegistryStatus < Base
    attribute :domain,          String
    attribute :registry_status, String # clientTransferProhibited
    
    def fetch
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      response = Client.get('/domain/registrystatus', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)
        
        @status = hash['status']
        @transaction_id = hash['transactid']

        if @status == 'SUCCESS'
          if hash['registrystatus'].is_a?(Array)
            @registry_status = hash['registrystatus'].first
          else
            @registry_status = hash['registrystatus']
          end
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
