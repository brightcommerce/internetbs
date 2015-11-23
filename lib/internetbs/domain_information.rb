module InternetBS
  class DomainInformation < Base
    attribute :auto_renew,         Boolean
    attribute :contacts,           Array[DomainContact]
    attribute :domain,             String
    attribute :domain_extension,   String
    attribute :domain_status,      String # REGISTERED, REGISTRAR LOCKED, PENDING TRANSFER, PENDING TRADE, ON HOLD, EXPIRED, UNKNOWN
    attribute :expiration_date,    Date
    attribute :private_whois,      String # DISABLED or FULL or PARTIAL
    attribute :registrar_lock,     String # ENABLED or DISABLED or NOTADMITTED
    attribute :transfer_auth_info, String
      
    def fetch
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      response = Client.get('/domain/info', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)        

        @status = hash['status']
        @transaction_id = hash['transactid']

        if @status == 'SUCCESS'
          @auto_renew         = hash['autorenew'] == 'YES' ? true : false
          @domain_extension   = @domain.split('.').last
          @domain_status      = hash['domainstatus']
          @expiration_date    = hash['expirationdate']
          @private_whois      = hash['privatewhois']
          @registrar_lock     = hash['registrarlock']
          @transfer_auth_info = hash['transferauthinfo']
        
          @contacts << DomainContact.new(
            :contact_type => 'registrant',
            :first_name   => hash['contacts']['registrant']['firstname'],
            :last_name    => hash['contacts']['registrant']['lastname'],
            :email        => hash['contacts']['registrant']['email'],
            :phone_number => hash['contacts']['registrant']['phonenumber'],
            :organization => hash['contacts']['registrant']['organization'],
            :city         => hash['contacts']['registrant']['city'],
            :street       => hash['contacts']['registrant']['street'],
            :street_2     => hash['contacts']['registrant']['street2'],
            :street_3     => hash['contacts']['registrant']['street3'],
            :postal_code  => hash['contacts']['registrant']['postalcode'],
            :country_code => hash['contacts']['registrant']['countrycode'],
            :country      => hash['contacts']['registrant']['country']
          )

          @contacts << DomainContact.new(
            :contact_type => 'tech',
            :first_name   => hash['contacts']['technical']['firstname'],
            :last_name    => hash['contacts']['technical']['lastname'],
            :email        => hash['contacts']['technical']['email'],
            :phone_number => hash['contacts']['technical']['phonenumber'],
            :organization => hash['contacts']['technical']['organization'],
            :city         => hash['contacts']['technical']['city'],
            :street       => hash['contacts']['technical']['street'],
            :street_2     => hash['contacts']['technical']['street2'],
            :street_3     => hash['contacts']['technical']['street3'],
            :postal_code  => hash['contacts']['technical']['postalcode'],
            :country_code => hash['contacts']['technical']['countrycode'],
            :country      => hash['contacts']['technical']['country']
          )

          @contacts << DomainContact.new(
            :contact_type => 'admin',
            :first_name   => hash['contacts']['admin']['firstname'],
            :last_name    => hash['contacts']['admin']['lastname'],
            :email        => hash['contacts']['admin']['email'],
            :phone_number => hash['contacts']['admin']['phonenumber'],
            :organization => hash['contacts']['admin']['organization'],
            :city         => hash['contacts']['admin']['city'],
            :street       => hash['contacts']['admin']['street'],
            :street_2     => hash['contacts']['admin']['street2'],
            :street_3     => hash['contacts']['admin']['street3'],
            :postal_code  => hash['contacts']['admin']['postalcode'],
            :country_code => hash['contacts']['admin']['countrycode'],
            :country      => hash['contacts']['admin']['country']
          )

          if @domain_extension == 'de'
            @contacts << DomainContact.new(
              :contact_type => 'zone',
              :first_name   => hash['contacts']['billing']['firstname'],
              :last_name    => hash['contacts']['billing']['lastname'],
              :email        => hash['contacts']['billing']['email'],
              :phone_number => hash['contacts']['billing']['phonenumber'],
              :organization => hash['contacts']['billing']['organization'],
              :city         => hash['contacts']['billing']['city'],
              :street       => hash['contacts']['billing']['street'],
              :street_2     => hash['contacts']['billing']['street2'],
              :street_3     => hash['contacts']['billing']['street3'],
              :postal_code  => hash['contacts']['billing']['postalcode'],
              :country_code => hash['contacts']['billing']['countrycode'],
              :country      => hash['contacts']['billing']['country']
          else
            @contacts << DomainContact.new(
              :contact_type => 'billing',
              :first_name   => hash['contacts']['billing']['firstname'],
              :last_name    => hash['contacts']['billing']['lastname'],
              :email        => hash['contacts']['billing']['email'],
              :phone_number => hash['contacts']['billing']['phonenumber'],
              :organization => hash['contacts']['billing']['organization'],
              :city         => hash['contacts']['billing']['city'],
              :street       => hash['contacts']['billing']['street'],
              :street_2     => hash['contacts']['billing']['street2'],
              :street_3     => hash['contacts']['billing']['street3'],
              :postal_code  => hash['contacts']['billing']['postalcode'],
              :country_code => hash['contacts']['billing']['countrycode'],
              :country      => hash['contacts']['billing']['country']
          end
        else
          set_errors(response)
          return false          
        end
        
        return true
      else
        set_errors(response)
        return false
      end
    end
  end
end
