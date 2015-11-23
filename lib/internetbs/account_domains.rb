module InternetBS
  class AccountDomains < Base
    attribute :compact_list,          Boolean, :default => true         # YES or NO
    attribute :expiring_only,         Integer                           # Number of days
    attribute :extension_filter,      String
    attribute :pending_transfer_only, Boolean, :default => false        # YES or NO
    attribute :range_from,            Integer
    attribute :range_to,              Integer
    attribute :search_term_filter,    String
    attribute :list,                  Array[AccountDomain]
    attribute :sort_by,               String, :default => 'DOMAIN_NAME' # DOMAIN_NAME, DOMAIN_NAME_DESC, EXPIRATION, EXPIRATION_DESC
    attribute :total_domains,         Integer
    attribute :total_domains_by_tld,  Array[DomainTotal]
    
    def fetch
      @errors.clear
      @list.clear
      @total_domains = 0
      @total_domains_by_tld = 0
      
      params = {'compactlist' => @compact_list ? 'YES' : 'NO', 'sortby' => @sort_by}
      params.merge!({'expiringonly' => @expiring_only}) if @expiring_only
      params.merge!({'extensionfilter' => @extension_filter}) if @extension_filter
      params.merge!({'pendingtransferonly' => 'YES'}) if @pending_transfer_only
      params.merge!({'rangefrom' => @range_from, 'rangeto' => @range_to}) if @range_from && @range_to
      params.merge!({'searchtermfilter' => @search_term_filter}) if @search_term_filter

      response = Client.get('/domain/list', params)
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)
        
        @status = hash.delete('status')
        @transaction_id = hash.delete('transactid')

        if @status == 'SUCCESS'
          @total_domains = hash['domaincount']
          
          if @compact_list
            hash['domain'].each do |domain|
              @list << AccountDomain.new(:name => domain)
            end
          else
            hash['domain'].each do |domain|
              @list << AccountDomain.new(
                :name => domain['name'],
                :expiration_date => domain['expiration'],
                :registrar_lock => domain['registrarlock'],
                :status => domain['status'],
                :transfer_auth_info => domain['transferauthinfo']
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
    
    def fetch_totals
      @errors.clear
      
      response = Client.get('/domain/count')
      code = response.code rescue ""
      
      case code
      when '200'
        hash = JSON.parse(response.body)
        
        @status = hash.delete('status')
        @transaction_id = hash.delete('transactid')

        if @status == 'SUCCESS'
          @total_domains = hash.delete('totaldomains')
          @total_domains_by_tld.clear
          
          hash.each do |tld, total| 
            @total_domains_by_tld << DomainTotal.new(:tld => tld, :total => total)
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
