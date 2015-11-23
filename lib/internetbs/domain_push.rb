module InternetBS
  class DomainPush < Base
    attribute :domain,        String # The domain being pushed
    attribute :email_address, String # The destination account's email address
  
    def push!
      ensure_attribute_has_value :domain, :email_address
      return false if @errors.any?
      
      params = {'domain' => @domain, 'destination' => @email_address}
      response = Client.post('/domain/push', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        unless @status == 'SUCCESS'
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
