module InternetBS
  class DotAsiaAttributes < AdditionalAttributes
    CED_ENTITY_TYPES = \
      %w[naturalperson corporation cooperative partnership government politicalparty society institution other]
      
    CED_ID_FORM_TYPES = \
      %w[passport certificate legislation societiesregistry policalpartyregistry other]
    
    # Additional attributes are for Charter Eligibility Declaration (CED)
    attribute :ced_locality,       String # Required
    attribute :ced_entity,         String # Required - must be one of CED_ENTITY_TYPES
    attribute :ced_entity_other,   String # Required if ced_entity is 'other'
    attribute :ced_id_form,        String # Required - must be one of CED_ID_FORM_TYPES
    attribute :ced_id_form_other,  String # Required if ced_id_form is 'other'
    attribute :ced_city,           String # Optional
    attribute :ced_id_number,      String # Optional
    attribute :ced_state_province, String # Optional
    
    def is_sunrise?
      false # Sunrise and landrush periods ended March, 26 2008 when .asia transitioned to GoLive
    end
    
    def mandatory_params
      params = {
        'dotasiacedlocality' => @ced_locality, 
        'dotasiacedentity' => @ced_entity, 
        'dotasiacedidform' => @ced_id_form
      }
      params.merge!({'dotasiacedentityother' => @ced_entity_other}) if @ced_entity == 'other'
      params.merge!({'dotasiacedidformother' => @ced_id_form_other}) if @ced_id_form == 'other'
      return params
    end
    
    def optional_params
      params = {}
      params.merge!({'dotasiacedcity' => @ced_city}) if @ced_city
      params.merge!({'dotasiacedidnumber' => @ced_id_number}) if @ced_id_number
      params.merge!({'dotasiacedstateprovince' => @ced_state_province}) if @ced_state_province
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :ced_locality, :ced_entity, :ced_id_form
      unless CED_ENTITY_TYPES.include?(@ced_entity)
        @errors << "ced_entity must be one of CED_ENTITY_TYPES"
      end
      unless CED_ID_FORM_TYPES.include?(@ced_id_form)
        @errors << "ced_id_form must be one of CED_ID_FORM_TYPES"
      end
      ensure_attribute_has_value :ced_entity_other if @ced_entity == 'other'
      ensure_attribute_has_value :ced_id_form_other if @ced_id_form == 'other'
      ensure_attribute_has_value :cd_id_number if is_sunrise?
      super
    end
  end
end
