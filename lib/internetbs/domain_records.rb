module InternetBS
  class DomainRecords < Base    
    attribute :domain,      String              # Only used by #fetch method
    attribute :filter_type, String              # One of DomainRecord::TYPES, only used by #fetch method
    attribute :list,        Array[DomainRecord]
    
    def add(dns_record)
      set_record :add, dns_record
    end
    
    def fetch
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      params.merge!({'filtertype' => @filter_type}) if @filter_type
        
      response = Client.get('/domain/dnsrecord/list', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        if @status == 'SUCCESS'
          hash['records'].each do |record|
            @list << DomainRecord.new(
              :name  => record['name'],
              :value => record['value'],
              :ttl   => record['ttl'],
              :type  => record['type']
            )
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
    
    def remove(dns_record)
      set_record :remove, dns_record
    end
    
    def update(current_dns_record, new_dns_record)
      @errors.clear
      
      unless current_dns_record.valid? && new_dns_record.valid?
        current_dns_record.each do |err|
          @errors << "current: #{err}"
        end
        
        new_dns_record.each do |err|
          @errors << "new: #{err}"
        end
        
        return false
      end
      
      params = {
        'fullrecordname' => current_dns_record.full_record_name,
        'type' => current_dns_record.type
      }

      if current_dns_record.value && dns_record.value
        params.merge!({ 
          'currentvalue' => current_dns_record.value, 
          'newvalue' => new_dns_record.value 
        })
      end
      
      if current_dns_record.ttl && \
         new_dns_record.ttl && \
         current_dns_record.ttl == new_dns_record.ttl
        params.merge!({ 
          'currentttl' => current_dns_record.ttl, 
          'newttl' => new_dns_record.ttl 
        })
      end
      
      if current_dns_record.type == 'MX' && \
         current_dns_record.priority && \
         new_dns_record.priority && 
         current_dns_record.priority == new_dns_record.priority
        params.merge!({ 
          'currentpriority' => current_dns_record.priority, 
          'newpriority' => new_dns_record.priority 
        })
      end
      
      response = Client.post("/domain/dnsrecord/update", params)
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
    
    private
    
    # Expects an action parameter of either :add or :remove.
    def set_record(action, dns_record)
      @errors.clear
      
      unless dns_record.valid?
        @errors = dns_record.errors
        return false
      end
      
      params = {
        'fullrecordname' => dns_record.full_record_name,
        'type'           => dns_record.type
      }

      if dns_record.value
        params.merge!({'value' => dns_record.value})
      end
      
      if action == :add
        if dns_record.ttl
          params.merge!({'ttl' => dns_record.ttl})
        end
        if dns_record.priority && dns_record.type == 'MX'
          params.merge!({'priority' => dns_record.priority})
        end
      end
        
      response = Client.post("/domain/dnsrecord/#{action.to_s}", params)
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
