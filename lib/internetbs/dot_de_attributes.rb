require_relative 'country_codes'

module InternetBS
  class DotDEAttributes < AdditionalAttributes
    ROLES = {
      'PERSON' => 'Natural person',
      'ROLE'   => 'An abstract name for a group of persons (so-called role account, e.g. Business Services)',
      'ORG'    => 'A legal person (company, association, grouping of holders, organization etc.)'
    }
        
    attribute :role,             String                     # Required - one in ROLES
    attribute :ip_address,       String                     # Required
    attribute :disclose_name,    Boolean, :default => false # Required
    attribute :disclose_contact, Boolean, :default => false # Required
    attribute :disclose_address, Boolean, :default => false # Required
    attribute :remark,           String                     # Optional
    attribute :sip_uri,          String                     # Optional
    attribute :terms_accepted,   Boolean, :default => false # Required
    
    def mandatory_params
      params = {"#{@contact_type.to_s}_role" => @role, "#{@contact_type.to_s}_clientip" => @ip_address}
      params.merge!({"#{@contact_type.to_s}_disclosename" => @disclose_name ? 'YES' : 'NO'})
      params.merge!({"#{@contact_type.to_s}_disclosecontact" => @disclose_contact ? 'YES' : 'NO'})
      params.merge!({"#{@contact_type.to_s}_discloseaddress" => @disclose_address ? 'YES' : 'NO'})
      params.merge!({"#{@contact_type.to_s}_tosagree" => @terms_accepted ? 'YES' : 'NO'})
      return params
    end
    
    def optional_params
      params = {}
      params.merge!({"#{@contact_type.to_s}_sip" => @sip_uri}) if @sip_uri
      params.merge!({"#{@contact_type.to_s}_remark" => @remark}) if @remark
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :role, :disclose_name, :disclose_contact, 
        :disclose_address, :terms_accepted, :ip_address
      unless ROLES.has_key?(@role)
        @errors << "role must be one in ROLES"
      else
        case @contact_type
        when :registrant
          unless ['PERSON', 'ORG'].include?(@role)
            @errors << 'role must be either PERSON or ORG for registrant contact'
          end
        when :admin
          unless ['PERSON'].include?(@role)
            @errors << 'role must be PERSON for admin contact'
          end
        when :tech
          unless ['PERSON', 'ORG'].include?(@role)
            @errors << 'role must be either PERSON or ORG for tech contact'
          end
        when :zone
          unless ['PERSON', 'ORG'].include?(@role)
            @errors << 'role must be either PERSON or ORG for zone contact'
          end
        end
      end
      super
    end
  end
end
