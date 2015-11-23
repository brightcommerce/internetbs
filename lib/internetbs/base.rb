require 'virtus'

module InternetBS
  class Base
    include Virtus.model
    include Virtus::Equalizer.new(name || inspect)

    attribute :errors,         Array[String]
    attribute :status,         String        # SUCCESS or FAILURE or PENDING
    attribute :transaction_id, String

    def inspect
      values = Hash[instance_variables.map{|name| [name, instance_variable_get(name)]}]
      "<#{self.class.name} #{values}>"
    end

    private
    
    def ensure_attribute_has_value(*attributes)
      @errors.clear
      attributes.each do |attr|
        unless instance_variable_get(("@" + attr.to_s).intern)
          @errors << "#{attr.to_s} is required"
        end
      end
    end
    
    def set_errors(response)
      hash = JSON.parse(response.body)
      @errors << hash["message"]
    end
  end
end