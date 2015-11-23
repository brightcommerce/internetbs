module InternetBS
  class RenewDomain < Base
    attribute :currency,             String, :default => 'USD'
    attribute :discount_code,        String 
    attribute :domain,               String
    attribute :period,               String, :default => '1Y'  # 1Y, 2Y up to 10Y
    attribute :total_price,          Float
    
    def purchase!
      ensure_attribute_has_value :domain
      return false if @errors.any?
      
      params = {'domain' => @domain}
      params.merge!({'period' => @period}) if @period
      params.merge!({'discountcode' => @discount_code}) if @discount_code
      
      response = Client.post('/domain/renew', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
        
        if @status == 'SUCCESS'
          @currency    = hash['currency']
          @total_price = hash['price']
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
