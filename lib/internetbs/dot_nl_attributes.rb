module InternetBS
  class DotNLAttributes < AdditionalAttributes
    LEGAL_FORMS = {
      'BGG'         => 'Non-Dutch EC company',
      'BRO'         => 'Non-Dutch legal form/enterprise/subsidiary',
      'BV'          => 'Limited company',
      'BVI/O'       => 'Limited company in formation',
      'COOP'        => 'Cooperative',
      'CV'          => 'Limited Partnership',
      'EENMANSZAAK' => 'Sole trader',
      'EESV'        => 'European Economic Interest Group',
      'KERK'        => 'Religious society',
      'MAATSCHAP'   => 'Partnership',
      'NV'          => 'Public Company',
      'OWM'         => 'Mutual benefit company',
      'PERSOON'     => 'Natural person',
      'REDR'        => 'Shipping company',
      'STICHTING'   => 'Foundation',
      'VERENIGING'  => 'Association',
      'VOF Trading' => 'partnership',
      'ANDERS'      => 'Other'
    }
        
    attribute :ip_address,          String                     # Required
    attribute :legal_form,          String                     # Required - one of LEGAL_FORMS
    attribute :registration_number, String                     # Optional
    attribute :terms_accepted,      Boolean, :default => false # Required - YES = true, NO = false
    
    def registrant_params
      params = {
        'registrant_nllegalform' => @legal_form,
        'registrant_nlterm'      => @terms_accepted ? 'YES' : 'NO',
        'registrant_clientip'    => @ip_address
      }
      params.merge!({'registrant_nlregnumber' => @registration_number}) if @registration_number
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :ip_address, :legal_form, :terms_accepted
      unless LEGAL_FORMS.include?(@legal_form)
        @errors << "legal_form must be one in LEGAL_FORMS"
      end
      super
    end
  end
end
