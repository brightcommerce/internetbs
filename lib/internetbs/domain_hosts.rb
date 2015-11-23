module InternetBS
  class DomainHosts < Base
    attribute :compact, Boolean, :default => true
    attribute :domain,  String
    attribute :list,    Array[DomainHost]
    
    def add(domain_host)
      set_record :create, domain_host
    end
    
    def fetch
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      params.merge!({'compactlist' => @compact ? 'YES' : 'NO'}) if @compact
        
      response = Client.get('/domain/host/list', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        if @status == 'SUCCESS'
          total_hosts = hash['total_hosts'].to_i
          if total_hosts > 0
            hash['host'].each do |key, value|
              @list << DomainHost.new(:host => value)
            end
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
    
    def remove(domain_host)
      set_record :delete, domain_host
    end
    
    def update(domain_host)
      set_record :update, domain_host
    end
    
    private
    
    # Expects an action parameter of either :create, :update or :delete.
    def set_record(action, domain_host)
      @errors.clear
      
      case action
      when :create, :update
        unless domain_host.valid?
          @errors = domain_host.errors
          return false
        end
      when :delete
        unless domain_host.host
          @errors = 'host is required'
          return false
        end
      end
      
      params = {'host' => domain.host}
      
      if [:create, :update].include?(action)
        params.merge!({:ip_list => @ip_addresses.join(',')})
      end
      
      response = Client.post("/domain/host/#{action.to_s}", params)
      
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
  end
end
