require_relative 'country_codes'

module InternetBS
  class DomainContact < Base
    attribute :additional_attributes, AdditionalAttributes
    attribute :city,                  String
    attribute :contact_type,          String  # Internal - symbol: one of :registrant, :admin, :billing, :tech, :zone
    attribute :country,               String  # Read only - returned by DomainInformation
    attribute :country_code,          String  # Must be one in COUNTRY_CODES
    attribute :email,                 String
    attribute :fax,                   String  # Optional - only supported for .uk
    attribute :first_name,            String
    attribute :last_name,             String
    attribute :obfuscate_email,       Boolean, :default => false # Optional - only supported for .com/.net/.tv, 1 = obfuscate, 0 = not
    attribute :organization,          String  # Required for .uk, otherwise optional, only effective when private whois is disabled
    attribute :phone_number,          String
    attribute :postal_code,           String
    attribute :street,                String
    attribute :street_2,              String  # Optional
    attribute :street_3,              String  # Optional
    
    def initialize(attributes = nil)
      super(attributes)
      
      # Add any additional attributes
      case @domain_extension
      when 'asia'
        @additional_attributes = DotAsiaAttributes.new
      when 'de'
        @additional_attributes = DotDEAttributes.new
      when 'eu'
        @additional_attributes = DotEUAttributes.new
      when 'fr', 're', 'pm', 'tf', 'wf', 'yt'
        @additional_attributes = DotFRAttributes.new
      when 'it'
        @additional_attributes = DotITAttributes.new
      when 'nl'
        @additional_attributes = DotDLAttributes.new
      when 'uk'
        @additional_attributes = DotUKAttributes.new
      when 'us'
        @additional_attributes = DotUSAttributes.new
      end
      
      # Set contact_type and domain_extension for additional attributes
      @additional_attributes.contact_type = @contact_type
      @additional_attributes.domain_extension = @domain_extension
    end
    
    def params
      contact = {
        "#{@contact_type.to_s}_firstname"    => @first_name,
        "#{@contact_type.to_s}_lastname"     => @last_name,
        "#{@contact_type.to_s}_email"        => @email,
        "#{@contact_type.to_s}_phone_number" => @phone_number,
        "#{@contact_type.to_s}_city"         => @city,
        "#{@contact_type.to_s}_street"       => @street,
        "#{@contact_type.to_s}_postal_code"  => @postal_code,
        "#{@contact_type.to_s}_country_code" => @country_code
      }
      
      if @organization || @domain_extension == 'uk'
        contact.merge!({"#{@contact_type.to_s}_organization" => @organization})
      end
      
      if @fax && @domain_extension == 'uk'
        contact.merge!({"#{@contact_type.to_s}_fax" => @fax})
      end
      
      if %w[com net tv].include?(@domain_extension)
        contact.merge!({"#{@contact_type.to_s}_obfuscateemail" => @obfuscate_email ? 1 : 0})
      end
      
      if @street_2
        contact.merge!({"#{@contact_type.to_s}_street2" => @street_2})
      end

      if @street_3
        contact.merge!({"#{@contact_type.to_s}_street3" => @street_3})
      end
      
      case @contact_type
      when :registrant
        contact.merge!(@additional_attributes.registrant_params)
      when :admin
        contact.merge!(@additional_attributes.admin_params)
      when :billing
        contact.merge!(@additional_attributes.billing_params)
      when :tech
        contact.merge!(@additional_attributes.tech_params)
      when :zone # .de only
        contact.merge!(@additional_attributes.zone_params) if @domain_extension == 'de'
      end

      contact.merge!(@additional_attributes.mandatory_params)
      contact.merge!(@additional_attributes.optional_params)
      
      return contact
    end
    
    def valid?
      ensure_attribute_has_value :first_name, :last_name, :email,
       :phone_number, :city, :street, :postal_code, :country_code
      unless COUNTRY_CODES.has_key?(@country_code)
        @errors << "country_code must be one in COUNTRY_CODES"
      end
    end
  end
end
