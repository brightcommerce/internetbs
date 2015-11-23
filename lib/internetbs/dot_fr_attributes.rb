require_relative 'country_codes'

module InternetBS
  class DotFRAttributes < AdditionalAttributes
    CONTACT_ENTITY_TYPES = %w[INDIVIDUAL COMPANY TRADEMARK ASSOCIATION OTHER]
    
    attribute :entity_type,                        String  # Must be one of CONTACT_ENTITY_TYPES
    attribute :entity_name,                        String
    attribute :entity_vat,                         String  # Optional
    attribute :entity_siren,                       String  # Optional
    attribute :entity_duns,                        String  # Optional
    attribute :entity_trade_mark,                  String
    attribute :entity_waldec,                      String
    attribute :entity_date_of_association,         Date    # YYYY-MM-DD
    attribute :entity_date_of_publication,         Date    # YYYY-MM-DD
    attribute :entity_gazette_announcement_number, String
    attribute :entity_gazette_page_number,         String 
    attribute :entity_birth_date,                  Date    # YYYY-MM-DD
    attribute :entity_birth_place_country_code,    String  # Must be one in COUNTRY_CODES
    attribute :entity_birth_city,                  String
    attribute :entity_birth_place_postal_code,     String
    attribute :entity_restricted_publication,      Boolean # 1 = true, 0 = false
    attribute :other_contact_entity,               String
    
    def registrant_params
      params = {"registrant_dot#{@domain_extension}contactentitytype" => @entity_type}
      case @entity_type
      when 'INDIVIDUAL'
        params.merge!({"registrant_dot#{@domain_extension}contactentitybirthdate" => @entity_birth_date.strftime('%Y-%m-%d')})
        params.merge!({"registrant_dot#{@domain_extension}contactentitybirthplacecountrycode" => @entity_birth_place_country_code})
        if @entity_birth_place_country_code == 'FR'
          params.merge!({"registrant_dot#{@domain_extension}contactentitybirthcity" => @entity_birth_city})
          params.merge!({"registrant_dot#{@domain_extension}contactentitybirthplacepostalcode" => @entity_birth_place_postal_code})
        end
      when 'COMPANY'
        params.merge!({"registrant_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"registrant_dot#{@domain_extension}contactentitysiren" => @entity_siren})
      when 'TRADEMARK'
        params.merge!({"registrant_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"registrant_dot#{@domain_extension}contactentitytrademark" => @entity_trade_mark})
      when 'ASSOCIATION'
        params.merge!({"registrant_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"registrant_dot#{@domain_extension}contactentitywaldec" => @entity_waldec})
        params.merge!({"registrant_dot#{@domain_extension}contactentitydateofassocation" => @entity_date_of_association.strftime('%Y-%m-%d')})
        params.merge!({"registrant_dot#{@domain_extension}contactentityannounceno" => @entity_gazette_announcement_number})
        params.merge!({"registrant_dot#{@domain_extension}contactentitydateofpublication" => @entity_date_of_publication.strftime('%Y-%m-%d')})
        params.merge!({"registrant_dot#{@domain_extension}contactentitypageno" => @entity_gazette_page_number})
      when 'OTHER'
        params.merge!({"registrant_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"registrant_dot#{@domain_extension}othercontactentity" => @other_contact_entity})
      end
      return params
    end
    
    def admin_params
      params = {"admin_dot#{@domain_extension}contactentitytype" => @entity_type}
      case @entity_type
      when 'INDIVIDUAL'
        params.merge!({"admin_dot#{@domain_extension}contactentitybirthdate" => @entity_birth_date.strftime('%Y-%m-%d')})
        params.merge!({"admin_dot#{@domain_extension}contactentitybirthplacecountrycode" => @entity_birth_place_country_code})
        if @entity_birth_place_country_code == 'FR'
          params.merge!({"admin_dot#{@domain_extension}contactentitybirthcity" => @entity_birth_city})
          params.merge!({"admin_dot#{@domain_extension}contactentitybirthplacepostalcode" => @entity_birth_place_postal_code})
        end
      when 'COMPANY'
        params.merge!({"admin_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"admin_dot#{@domain_extension}contactentitysiren" => @entity_siren})
      when 'TRADEMARK'
        params.merge!({"admin_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"admin_dot#{@domain_extension}contactentitytrademark" => @entity_trade_mark})
      when 'ASSOCIATION'
        params.merge!({"admin_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"admin_dot#{@domain_extension}contactentitywaldec" => @entity_waldec})
        params.merge!({"admin_dot#{@domain_extension}contactentitydateofassocation" => @entity_date_of_association.strftime('%Y-%m-%d')})
        params.merge!({"admin_dot#{@domain_extension}contactentityannounceno" => @entity_gazette_announcement_number})
        params.merge!({"admin_dot#{@domain_extension}contactentitydateofpublication" => @entity_date_of_publication.strftime('%Y-%m-%d')})
        params.merge!({"admin_dot#{@domain_extension}contactentitypageno" => @entity_gazette_page_number})
      when 'OTHER'
        params.merge!({"admin_dot#{@domain_extension}contactentityname" => @entity_name})
        params.merge!({"admin_dot#{@domain_extension}othercontactentity" => @other_contact_entity})
      end
      return params
    end
    
    def optional_params
      params = {}
      if @entity_type == 'INDIVIDUAL'
        if @entity_birth_date
          params.merge!({"#{@contact_type.to_s}_dot#{@domain_extension}contactentitybirthdate" => @entity_birth_date})
        end
        if @entity_birth_place_country_code
          params.merge!({"#{@contact_type.to_s}_dot#{@domain_extension}contactentitybirthplacecountrycode" => @entity_birth_place_country_code})
        end
        if @entity_birth_city
          params.merge!({"#{@contact_type.to_s}_dot#{@domain_extension}contactentitybirthcity" => @entity_birth_city})
        end
        if @entity_birth_place_postal_code
          params.merge!({"#{@contact_type.to_s}_dot#{@domain_extension}contactentitybirthplacepostalcode" => @entity_birth_place_postal_code})
        end
        if @entity_restricted_publication
          params.merge!({"#{@contact_type.to_s}_dot#{@domain_extension}contactentityrestrictedpublication" => @entity_restricted_publication == true ? 1 : 0})
        end
      end
      if @entity_vat
        params.merge!({"#{@contact_type.to_s}_dot#{@domain_extension}contactentityvat" => @entity_vat})
      end
      if @entity_duns
        params.merge!({"#{@contact_type.to_s}_dot#{@domain_extension}contactentityduns" => @entity_duns})
      end
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :entity_type
      case @entity_type
      when 'INDIVIDUAL'
        unless COUNTRY_CODES.has_key?(@entity_birth_place_country_code)
          @errors << "entity_birth_place_country_code must be one in COUNTRY_CODES"
        end
        if @entity_birth_place_country_code == 'FR'
          ensure_attribute_has_value :entity_birth_city, :entity_birth_place_postal_code
        end
      case 'COMPANY'
        ensure_attribute_has_value :entity_name
      case 'TRADEMARK'
        ensure_attribute_has_value :entity_name, :entity_trade_mark
      case 'ASSOCIATION'
        ensure_attribute_has_value :entity_name
        unless @entity_waldec
          ensure_attribute_has_value :entity_date_of_association, :entity_date_of_publication, :entity_announce_no, :entity_page_no
        end
      case 'ENTITY'
        ensure_attribute_has_value :entity_name
      end 
      super   
    end
  end
end
