require_relative 'country_codes'

module InternetBS
  class DotUSAttributes < AdditionalAttributes
    PURPOSES = {
      'P1' => 'Business use for profit',
      'P2' => 'Non-profit business, club, association, religious organization, etc.',
      'P3' => 'Personal use',
      'P4' => 'Educational purposes',
      'P5' => 'Government purposes'
    }
    
    NEXUS_CATEGORIES = {
      'C11' => 'A natural person who is a US Citizen',
      'C12' => 'A natural person who is a Permanent Resident',
      'C21' => 'An entity or organization that is (i) incorporated within one of the fifty US states, the District of Columbia, or any of the US possessions or territories, or (ii) organized or otherwise constituted under the laws of a state of the US, the District of Columbia or any of its possessions and territories (including federal, state, or local government of the US, or a political subdivision thereof, and non-commercial organizations based in the US.)',
      'C31' => 'A foreign organization that regularly engages in lawful activities (sales of goods or services or other business, commercial, or non-commercial, including not for profit relations) in the United States.',
      'C32' => 'Organization has an office or other facility in the US'
    }
    
    attribute :purpose,        String # Required - one of PURPOSES
    attribute :nexus_category, String # Required - one of NEXUS_CATEGORIES
    attribute :nexus_country,  String # Required if nexus_category is C31 or C32 - one of COUNTRY_CODES
    
    def registrant_params
      params = {'registrant_uspurpose' => @purpose, 'registrant_usnexuscategory' => @nexus_category}
      if ['C31', 'C32'].include?(@nexus_category)
        params.merge!({'registrant_usnexuscountry' => @nexus_country})
      end
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :purpose, :nexus_category
      unless PURPOSES.include?(@purpose)
        @errors << "purpose must be one in PURPOSES"
      end
      unless NEXUS_CATEGORIES.inlcude?(@nexus_category)
        @errors << "nexus_category must be one in NEXUS_CATEGORIES"
      end
      case @nexus_category
      when 'C31', 'C32'
        unless @nexus_country
          @errors << "nexus_country is required"
        else
          unless COUNTRY_CODES.has_key?(@nexus_country)
            @errors << "nexus_country must be one in COUNTRY_CODES"
          end
        end
      end
      super
    end
  end
end
