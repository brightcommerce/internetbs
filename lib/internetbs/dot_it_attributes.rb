require_relative 'country_codes'

module InternetBS
  class DotITAttributes < AdditionalAttributes
    ENTITY_TYPES = {
      '1' => 'Italian and foreign natural persons',
      '2' => 'Companies/one man companies',
      '3' => 'Freelance workers/professionals',
      '4' => 'Non-profit organizations',
      '5' => 'Public organizations',
      '6' => 'Other subjects',
      '7' => 'Foreigners who match 2-6'
    }
    
    # From ISO 3166-2:IT @ https://en.wikipedia.org/wiki/ISO_3166-2:IT
    PROVINCIAL_CODES = {
      "AG" =>	"Agrigento",
      "AL" =>	"Alessandria",
      "AN" =>	"Ancona",
      "AO" =>	"Aosta, Aoste (fr)",
      "AR" =>	"Arezzo",
      "AP" =>	"Ascoli Piceno",
      "AT" =>	"Asti",
      "AV" =>	"Avellino",
      "BA" =>	"Bari",
      "BT" =>	"Barletta-Andria-Trani",
      "BL" =>	"Belluno",
      "BN" =>	"Benevento",
      "BG" =>	"Bergamo",
      "BI" =>	"Biella",
      "BO" =>	"Bologna",
      "BZ" =>	"Bolzano, Bozen (de)",
      "BS" =>	"Brescia",
      "BR" =>	"Brindisi",
      "CA" =>	"Cagliari",
      "CL" =>	"Caltanissetta",
      "CB" =>	"Campobasso",
      "CI" =>	"Carbonia-Iglesias",
      "CE" =>	"Caserta",
      "CT" =>	"Catania",
      "CZ" =>	"Catanzaro",
      "CH" =>	"Chieti",
      "CO" =>	"Como",
      "CS" =>	"Cosenza",
      "CR" =>	"Cremona",
      "KR" =>	"Crotone",
      "CN" =>	"Cuneo",
      "EN" =>	"Enna",
      "FM" =>	"Fermo",
      "FE" =>	"Ferrara",
      "FI" =>	"Firenze",
      "FG" =>	"Foggia",
      "FC" =>	"Forlì-Cesena",
      "FR" =>	"Frosinone",
      "GE" =>	"Genova",
      "GO" =>	"Gorizia",
      "GR" =>	"Grosseto",
      "IM" =>	"Imperia",
      "IS" =>	"Isernia",
      "SP" =>	"La Spezia",
      "AQ" =>	"L'Aquila",
      "LT" =>	"Latina",
      "LE" =>	"Lecce",
      "LC" =>	"Lecco",
      "LI" =>	"Livorno",
      "LO" =>	"Lodi",
      "LU" =>	"Lucca",
      "MC" =>	"Macerata",
      "MN" =>	"Mantova",
      "MS" =>	"Massa-Carrara",
      "MT" =>	"Matera",
      "VS" =>	"Medio Campidano",
      "ME" =>	"Messina",
      "MI" =>	"Milano",
      "MO" =>	"Modena",
      "MB" =>	"Monza e Brianza",
      "NA" =>	"Napoli",
      "NO" =>	"Novara",
      "NU" =>	"Nuoro",
      "OG" =>	"Ogliastra",
      "OT" =>	"Olbia-Tempio",
      "OR" =>	"Oristano",
      "PD" =>	"Padova",
      "PA" =>	"Palermo",
      "PR" =>	"Parma",
      "PV" =>	"Pavia",
      "PG" =>	"Perugia",
      "PU" =>	"Pesaro e Urbino",
      "PE" =>	"Pescara",
      "PC" =>	"Piacenza",
      "PI" =>	"Pisa",
      "PT" =>	"Pistoia",
      "PN" =>	"Pordenone",
      "PZ" =>	"Potenza",
      "PO" =>	"Prato",
      "RG" =>	"Ragusa",
      "RA" =>	"Ravenna",
      "RC" =>	"Reggio Calabria",
      "RE" =>	"Reggio Emilia",
      "RI" =>	"Rieti",
      "RN" =>	"Rimini",
      "RM" =>	"Roma",
      "RO" =>	"Rovigo",
      "SA" =>	"Salerno",
      "SS" =>	"Sassari",
      "SV" =>	"Savona",
      "SI" =>	"Siena",
      "SR" =>	"Siracusa",
      "SO" =>	"Sondrio",
      "TA" =>	"Taranto",
      "TE" =>	"Teramo",
      "TR" =>	"Terni",
      "TO" =>	"Torino",
      "TP" =>	"Trapani",
      "TN" =>	"Trento",
      "TV" =>	"Treviso",
      "TS" =>	"Trieste",
      "UD" =>	"Udine",
      "VA" =>	"Varese",
      "VE" =>	"Venezia",
      "VB" =>	"Verbano-Cusio-Ossola",
      "VC" =>	"Vercelli",
      "VR" =>	"Verona",
      "VV" =>	"Vibo Valentia",
      "VI" =>	"Vicenza",
      "VT" =>	"Viterbo"
    }
    
    attribute :entity_type,      String                     # Required - one in ENTITY_TYPES
    attribute :nationality,      String                     # Required - one in COUNTRY_CODES
    attribute :reg_code,         String
    attribute :hide_whois,       Boolean, :default => false
    attribute :province,         String                     # One in PROVINCIAL_CODES if nationality = IT
    attribute :terms_1_accepted, Boolean, :default => false
    attribute :terms_2_accepted, Boolean, :default => false
    attribute :terms_3_accepted, Boolean, :default => false
    attribute :terms_4_accepted, Boolean, :default => false
    attribute :ip_address,       String
    
    def registrant_params
      params = {
        'registrant_dotitentitytype'  => @entity_type,
        'registrant_dotitnationality' => @nationality,
        'registrant_dotitregcode'     => @reg_code,
        'registrant_dotithidewhois'   => @hide_whois ? 'YES' : 'NO',
        'registrant_dotitprovince'    => @province,
        'registrant_dotitterm1'       => @term_1 ? 'YES' : 'NO',
        'registrant_dotitterm2'       => @term_2 ? 'YES' : 'NO',
        'registrant_dotitterm3'       => @term_3 ? 'YES' : 'NO',
        'registrant_dotitterm4'       => @term_4 ? 'YES' : 'NO',
        'registrant_clientip'         => @ip_address
      }
      return params
    end
    
    def valid?(inputs = {})
      ensure_attribute_has_value :entity_type, :nationality, :reg_code, :province, :ip_address
      
      unless COUNTRY_CODES.has_key?(@nationality)
        @errors << "nationality must be one in COUNTRY_CODES"
      end
      
      if @nationality == 'IT'
        unless PROVINCIAL_CODES.include?(@province)
          @errors << "province must be one in PROVINCIAL_CODES when nationality is IT"
        end
      end
      
      case @entity_type
      when '1'
        unless COUNTRY_CODES_EU.include?(@nationality) || COUNTRY_CODES_EU.include?(inputs['registrant_country_code'])
          @errors << "either nationality or registrant country_code must be member of EU"
        end
      else
        unless @nationality != inputs['registrant_country_code']
          @errors << "nationality must be the same as registrant country_code"
        end
      end
      super
    end
  end
end
