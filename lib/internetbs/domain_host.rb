module InternetBS
  class DomainHost < Base
    attribute :host,         String
    attribute :ip_addresses, Array[String]
  
    def fetch
      ensure_attribute_has_value :host
      return false if @errors.any?
      
      params = {'host' => @host}
      response = Client.get('/domain/host/info', params)
      
      case response.code
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
  
    def valid?
      ensure_attribute_has_value :host
      
      unless ip_addresses.any?
        @errors << 'at least one ip address is required'
      end

      if @errors.any?
        return false
      else
        return true
      end
    end
  end
end
