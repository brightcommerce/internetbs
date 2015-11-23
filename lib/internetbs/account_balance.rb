module InternetBS
  class AccountBalance
    include Virtus.model
    
    attribute :currency, String
    attribute :amount,   Float
  end
end
