require_relative 'language_codes'

module InternetBS
  class DotEUAttributes < AdditionalAttributes
    attribute :language, String # Required - must be one of LANGUAGE_CODES
    
    def registrant_params
      params = {'registrant_language' => @language}
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :language
      unless @language && LANGUAGE_CODES.include?(@language)
        @errors << "language must be one of LANGUAGE_CODES"
      end
      super
    end
  end
end
