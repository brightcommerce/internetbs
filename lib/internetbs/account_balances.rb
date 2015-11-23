module InternetBS
  class AccountBalances < Base
    attribute :list,     Array[AccountBalance]
    attribute :currency, String

    def fetch
      @errors.clear
      
      params = {} 
      params.merge!({'currency' => @currency}) if @currency
      response = Client.get('/account/balance/get', params)
      code = response.code rescue ""
      
      case code
      when '200'  
        hash = JSON.parse(response.body)

        @status = hash['status']
        @transaction_id = hash['transactid']
    
        if @status == 'SUCCESS'
          hash['balance'].each do |balance|
            @list << AccountBalance.new(
              :amount => balance['amount'], 
              :currency => balance['currency']
            )
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