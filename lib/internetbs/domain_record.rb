module InternetBS
  class DomainRecord < Base
    TYPES = ['A', 'AAAA', 'DYNAMIC', 'CNAME', 'MX', 'SRV', 'TXT', 'NS'].freeze
    
    attribute :name,     String
    attribute :priority, Integer, :default => 10   # Used for MX type records (optional)
    attribute :ttl,      Integer, :default => 3600 # 1 hour (optional)
    attribute :type,     String  # One of DomainRecord::TYPES
    attribute :value,    String
    
  # attribute :dyn_dns_login,    String  # Required for DYNAMIC records, ignored for all others, 1 - 30 chars
  # attribute :dyn_dns_password, String  # Required for DYNAMIC records, ignored for all others, 1 - 30 chars
  # attribute :at_registry,      Boolean # Only valid for .de & will be ignored for all other domains
  
    def valid?
      ensure_attribute_has_value :full_record_name, :type, :value

      if @type
        unless TYPES.include?(@type.upcase!)
          @errors << "type must be one of: #{TYPES.join(', ')}"
        end
      end

      if @errors.any?
        return false
      else
        return true
      end
    end
  end
end
