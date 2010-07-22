begin
  require "httparty"
rescue LoadError
  require "rubygems"
  require "httparty"
end

class GroopBuyr
  include HTTParty
  format :json
  
  def initialize(options = {})
    @base_url = "http://api.groopbuy.com/get"
    @version = "1.0"
    @format = :json
  end
  
  def cities
    parsed_response = self.class.get("#{@base_url}/cities?format=#{@format}&v=#{@version}").parsed_response
    
    raise parsed_response["error"].collect {|e| e["errorMessage"] }.join("\n") if parsed_response["error"]
    
    parsed_response["city"].collect { |c| City.new(c) }
  end
  
  def deals(city_code)
    parsed_response = self.class.get("#{@base_url}/deals/#{city_code}?format=#{@format}&v=#{@version}").parsed_response
    
    raise parsed_response["error"].collect {|e| e["errorMessage"] }.join("\n") if parsed_response["error"]
    
    parsed_response["deal"].collect { |d| Deal.new(d) }
  end
  
  protected
    class City
      attr_accessor  :cityName, :cityCode

      def initialize(options = {})
        options.each do |k, v|
          if respond_to?(k.to_sym)
            send("#{k}=".to_sym, v)
          end
        end
      end
      
      protected :cityName=, :cityCode=    
    end
    
    class Deal
      attr_accessor  :dealSource, :dealExpirationDateTime, :dealImageUrl, :dealHeadline, :dealExpirationDateTimeZone,
                          :dealUrl, :dealAmount, :dealSourceUrl, :dealValue

      def initialize(options = {})
        options.each do |k, v|
          if respond_to?(k.to_sym)
            send("#{k}=".to_sym, v)
          end
        end
      end
      
      protected :dealSource=, :dealExpirationDateTime=, :dealImageUrl=, :dealHeadline=, :dealExpirationDateTimeZone=,
                    :dealUrl=, :dealAmount=, :dealSourceUrl, :dealValue=
    end
end