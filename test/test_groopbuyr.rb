require 'helper'

class TestGroopbuyr < Test::Unit::TestCase
  def test_cities
    @cities = @groop_buyr.cities
    
    assert_equal Array, @cities.class
    assert_equal "Houston", @cities.detect {|c| c.cityCode == "HOU"}.cityName
  end

  def test_deals_for_valid_city
    @deals = @groop_buyr.deals("HOU")
    
  end
  
  def test_deals_for_invalid_city
    assert_raise RuntimeError do
      @deals = @groop_buyr.deals("HOT")
    end
  end
  
  def setup
    @groop_buyr = GroopBuyr.new
  end
end
