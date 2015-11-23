module InternetBS
  class AccountPrices < Base
    attribute :currency,      String, :default => 'USD'
    attribute :discount_code, String
    attribute :level,         String
    attribute :list,          Array[AccountPrice]
    attribute :version,       Integer, :default => 1 # 1 or 2
    
    def fetch
      @errors.clear
      
      params = {'currency' => @currency, 'version' => @version}
      optional_params = {'discountcode' => @discount_code}
      params.merge!(optional_params) if @discount_code
      
      response = Client.get('/account/pricelist/get', params)      
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)
    
        @status = hash["status"]
        @transaction_id = hash["transactid"]
        
        if @status == 'SUCCESS'
          case @version
          when 1
            hash['product'].each do |product|
              @list << AccountPrice.new(
                :currency     => @currency,
                :name         => product['name'], 
                :price_1_year => product['price']
              )
            end
          when 2
            @level    = hash['pricelevel']
            @currency = hash['currency']
          
            hash['product'].each do |product|
              @list << AccountPrice.new(
                :currency       => @currency,
                :name           => product['type'], 
                :operation      => product['operation'],
                :price_1_year   => product['period']['1'],
                :price_2_years  => product['period']['2'],
                :price_3_years  => product['period']['3'],
                :price_4_years  => product['period']['4'],
                :price_5_years  => product['period']['5'],
                :price_6_years  => product['period']['6'],
                :price_7_years  => product['period']['7'],
                :price_8_years  => product['period']['8'],
                :price_9_years  => product['period']['9'],
                :price_10_years => product['period']['10']
              )
            end
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