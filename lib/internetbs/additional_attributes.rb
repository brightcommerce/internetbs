module InternetBS
  class AdditionalAttributes < Base
    attribute :contact_type,     String # Internal - symbol: one of :registrant, :admin, :billing, :tech, :zone
    attribute :domain_extension, String
    
    def admin_params
      return {}
    end
    
    def billing_params
      return {}
    end
    
    # Mandatory attributes for all contact types
    def mandatory_params
      return {}
    end
    
    # Optional attributes for all contact types
    def optional_params
      return {}
    end
    
    def registrant_params
      return {}
    end
    
    def valid?(inputs = {})
      if @errors.any?
        return false
      else
        return true
      end
    end
    
    # .de domains only - substituted with billing contact
    def zone_params
      return {}
    end
  end
end
