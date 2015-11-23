module InternetBS
  class DotUKAttributes < AdditionalAttributes
    ORGANIZATION_TYPES = {
      'LTD'    => 'UK Limited Company',
      'PLC'    => 'UK Public Limited Company',
      'PTNR'   => 'UK Partnership',
      'STRA'   => 'UK Sole Trader',
      'LLP'    => 'UK Limited Liability Partnership',
      'IP'     => 'UK Industrial/Provident Registered Company',
      'IND'    => 'UK Individual (self representing)',
      'SCH'    => 'UK School',
      'RCHAR'  => 'UK Registered Charity',
      'GOV'    => 'UK Government Body',
      'CRO'    => 'UK Corporation by Royal Charter',
      'STAT'   => 'UK Statutory Body',
      'OTHER'  => 'UK Entity that does not fit into any of the above',
      'FIND'   => 'Non-UK Individual (self representing)',
      'FCORP'  => 'Non-UK Corporation',
      'FOTHER' => 'Non-UK Entity that does not fit into any of the above'
    }
    
    attribute :county,              String
  # attribute :locality,            String                     # DEPRECATED
  # attribute :mobile,              String                     # DEPRECATED
    attribute :opt_out,             Boolean, :default => false # Y = hide, N = no hide, only for FIND or IND
    attribute :organization_type,   String                     # Required, must be one of ORGANIZATION_TYPES
    attribute :organization_number, String                     # Required if LTD, PLC, LLP, IP, SCH, RCHAR
    attribute :registration_number, String                     # Required for LTD, PLC, LLP, IP, SCH, RCHAR
    
    def registrant_params
      params = {'registrant_county' => @county, 'registrant_dotukorgtype' => @organization_type}
      if %w[LTD PLC LLP IP SCH RCHAR].include?(@organization_type)
        params.merge!({
          'registrant_dotukorgno' => @organization_number, 
          'registrant_dotukregistrationnumber' => @registration_number
        })
      end
      returns params
    end
    
    def optional_params
      params = {} 
      if %w[IND FIND].include?(@organization_type)
        params.merge!({"#{@contact_type.to_s}_dotukoptout" => @opt_out ? 'Y' : 'N'})
      end
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :county, :organization_type
      unless ORGANIZATION_TYPES.has_key?(@organization_type)
        @errors << "organization_type must be one in ORGANIZATION_TYPES"
      end
      if %w[LTD PLC LLP IP SCH RCHAR].include?(@organization_type)
        ensure_attribute_has_value :organization_number, :registration_number
      end
      super
    end
  end
end
