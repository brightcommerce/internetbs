module InternetBS
  class AccountPrice
    include Virtus.model
    
    attribute :currency,       String
    attribute :name,           String
    attribute :operation,      String
    attribute :price_1_year,   Float
    attribute :price_2_years,  Float
    attribute :price_3_years,  Float
    attribute :price_4_years,  Float
    attribute :price_5_years,  Float
    attribute :price_6_years,  Float
    attribute :price_7_years,  Float
    attribute :price_8_years,  Float
    attribute :price_9_years,  Float
    attribute :price_10_years, Float
  end
end
