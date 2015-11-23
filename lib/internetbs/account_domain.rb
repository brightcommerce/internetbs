module InternetBS
  class AccountDomain
    include Virtus.model
    
    attribute :name,               String
    attribute :expiration_date,    Date
    attribute :registrar_lock,     String # ENABLED or DISABLED or NOTADMITTED
    attribute :status,             String
    attribute :transfer_auth_info, String
  end
end
