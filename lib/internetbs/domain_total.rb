module InternetBS
  class DomainTotal
    include Virtus.model
    
    attribute :tld, String
    attribute :total, Integer
  end
end
