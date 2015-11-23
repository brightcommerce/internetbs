module InternetBS
  class AccountTransaction
    include Virtus.model
    
    attribute :currency, String
    attribute :name,     String
    attribute :price,    Float
  end
end
