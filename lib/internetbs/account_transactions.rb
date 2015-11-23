module InternetBS
  class AccountTransactions < Base
    attribute :client_transaction_id, String
    attribute :currency,              String, :default => 'USD'
    attribute :list,                  Array[AccountTransaction]
    attribute :response_type,         String, :default => 'EXACT_RESPONSE' # EXACT_RESPONSE, RESPONSE_DATA or REQUEST_DATA
    
    def fetch
      @errors.clear
      
      params = {}
      params.merge!({'transaction_id' => @transaction_id}) if @transaction_id
      params.merge!({'client_transaction_id' => @client_transaction_id}) if @client_transaction_id
      
      response = Client.get('/account/transactioninfo/get', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)
    
        @status = hash["status"]
        @transaction_id = hash["transactid"]

        # Receiving: "FAILURE", "Permission Denied %1%"
        # This endpoint may require activation by InternetBS themselves?
        # Documentation exists in PDF only. May be an artifact, but would
        # expect to receive an error stating the endpoint doesn't exist.
        debugger
        puts hash
        
        if @status == 'SUCCESS'
          @currency = hash['currency']
        
          hash['product'].each do |product|
            @list << AccountTransaction.new(
              :currency => @currency ,
              :name     => product['name'], 
              :price    => product['price']
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