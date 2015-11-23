module InternetBS
  class RegistrarLock < Base
    attribute :domain, String
    attribute :lock_status, String # LOCKED or UNLOCKED
    
    def disable
      set_registrar_lock_status :disable
    end
    
    def enable
      set_registrar_lock_status :enable
    end
    
    def fetch
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      response = Client.get('/domain/registrarlock/status', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)
        
        @status = hash['status']
        @transaction_id = hash['transactid']

        if @status == 'SUCCESS'
          @lock_status = hash['registrar_lock_status']
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
    def set_registrar_lock_status(action)
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      response = Client.post("/domain/registrarlock/#{action.to_s}", params)
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
