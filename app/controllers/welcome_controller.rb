class WelcomeController < ApplicationController
  def test
  	response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/CA/San_Diego.json")

  	@location = response['location']['city']
  	@temp_f = response['current_observation']['temp_f']
  	@temp_c = response['current_observation']['temp_c']
  	@weather_icon = response['current_observation']['icon_url']
	  @weather_words = response['current_observation']['weather'] 
	  @forecast_link = response['current_observation']['forecast_url']
	  @real_feel = response['current_observation']['feelslike_f']
  end

  def index
  	@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NE KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC PR)
    @states.sort!

    @location_list = Location.all

    if params[:city] != nil

    	location_exists = false
    	Location.all.each do |l|
    		if l.city == params[:city] && l.state == params[:state]
    			location_exists = true
    		end
    	end

			if location_exists == false    	
	    	location = Location.new
	    	location.city = params[:city]
	    	location.state = params[:state]
	    	location.save
	    end

    	params[:city] = params[:city].gsub(" ", "_")

	    response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/#{params[:state]}/#{params[:city]}.json")

	  	@location = response['location']['city']
	  	@temp_f = response['current_observation']['temp_f']
	  	@temp_c = response['current_observation']['temp_c']
	  	@weather_icon = response['current_observation']['icon_url']
		  @weather_words = response['current_observation']['weather'] 
		  @forecast_link = response['current_observation']['forecast_url']
		  @real_feel = response['current_observation']['feelslike_f']

		if @weather_words == "Rain"
			@body_class="rain"
		elsif @weather_words == "Clear"
			@body_class="sunny"
		elsif @weather_words == "Flurries"
			@body_class="storm"
		elsif @weather_words == "Fog"
			@body_class="cloudy"
		elsif @weather_words == "Haze"
			@body_class="baby_blue"
		elsif @weather_words == "MostlyCloudy"
			@body_class="cloudy"
		elsif @weather_words == "MostlySunny"
			@body_class="sunny"
		elsif @weather_words == "PartlySunny"
			@body_class="sunny"
		elsif @weather_words == "FreezingRain"
			@body_class="storm"
		elsif @weather_words == "Rain"
			@body_class="storm"
		elsif @weather_words == "Sleet"
			@body_class="storm"
		elsif @weather_words == "Snow"
			@body_class="storm"
		elsif @weather_words == "Sunny"
			@body_class="sunny"
		elsif @weather_words == "Thunderstorms"
			@body_class="storm"
		elsif @weather_words == "Overcast"
			@body_class="cloudy"
		elsif @weather_words == "ScatteredClouds"
			@body_class="cloudy"
		end
	end
  end
end

