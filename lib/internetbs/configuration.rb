module InternetBS
  class Configuration
    attr_writer :credentials
    
    def api_key
      InternetBS.credentials[InternetBS.environment][:api_key]
    end
    
    def api_key=(value)
      InternetBS.credentials[InternetBS.environment][:api_key] = value
    end

    def api_pwd
      InternetBS.credentials[InternetBS.environment][:api_pwd]
    end
    
    def api_pwd=(value)
      InternetBS.credentials[InternetBS.environment][:api_pwd] = value
    end
    
    def api_uri
      InternetBS.credentials[InternetBS.environment][:api_uri]
    end
    
    def api_uri=(value)
      InternetBS.credentials[InternetBS.environment][:api_uri] = value
    end
    
    def credentials
      @credentials ||= {
        :production => {
          :api_key => ENV['INTERNETBS_API_KEY'],
          :api_pwd => ENV['INTERNETBS_API_PWD'],
          :api_uri => "https://api.internet.bs"
        },
        :test => {
          :api_key => "testapi",
          :api_pwd => "testpass",
          :api_uri => "https://testapi.internet.bs"
        },
        :development => {
          :api_key => "testapi",
          :api_pwd => "testpass",
          :api_uri => "https://testapi.internet.bs"
        }
      }
    end
    
    def environment
      @environment ||= :production
    end
    
    def environment=(value)
      @environment = value.is_a?(String) ? value.to_sym : value
    end
    
    def environments
      InternetBS.credentials.keys
    end
  end
end
