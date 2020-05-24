#!/bin/bash 

get_icon() {
    case $1 in
        01d) icon="🌣";;
        01n) icon="☾";;
        02d) icon="🌥";;
        02n) icon="☁";;
        03*) icon="☁";;
        04*) icon="☁";;
        09d) icon="☁";;
        09n) icon="☁";;
        10d) icon="🌦";;
        10n) icon="🌧";;
        11d) icon="🌩";;
        11n) icon="🌩";;
        13d) icon="❆";;
        13n) icon="❆";;
        50d) icon="";;
        50n) icon="";;
        *) icon="🌣";
    esac

    echo $icon
}

get_png() {
    case $1 in
        01d) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/01d@2x.png;;
        01n) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/01n@2x.png;;
        02d) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/02d@2x.png;;
        02n) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/02n@2x.png;;
        03*) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/03@2x.png;;
        04*) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/04@2x.png;;
        09d) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/09@2x.png;;
        09n) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/09@2x.png;;
        10d) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/10d@2x.png;;
        10n) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/10n@2x.png;;
        11d) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/11@2x.png;;
        11n) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/11@2x.png;;
        13d) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/13@2x.png;;
        13n) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/13@2x.png;;
        50d) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/50d@2x.png;;
        50n) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/50n@2x.png;;
        *) icon=$HOME/.config/i3status/i3status_scripts/weather-icon/01d@2x.png;
    esac

    echo $icon
}

KEY="365a6f3a274bba21cabdbee0aa44e99f"
CITY="3451190"
UNITS="metric"
SYMBOL="°"

API="https://api.openweathermap.org/data/2.5"

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    current=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    forecast=$(curl -sf "$API/forecast?appid=$KEY&$CITY_PARAM&units=$UNITS&cnt=1")
else
    location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        current=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
        forecast=$(curl -sf "$API/forecast?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS&cnt=1")
    fi
fi

if [ -n "$current" ] && [ -n "$forecast" ]; then
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")
    current_desc=$(echo "$current" | jq -r ".weather[0].description")

    forecast_temp=$(echo "$forecast" | jq ".list[].main.temp" | cut -d "." -f 1)
    forecast_icon=$(echo "$forecast" | jq -r ".list[].weather[0].icon")

    if [ "$current_temp" -gt "$forecast_temp" ]; then
        trend="⬊"
    elif [ "$forecast_temp" -gt "$current_temp" ]; then
        trend="⬈"
    else
        trend="🢚"
    fi
    
	NOTIFY="$(get_icon "$current_icon") $current_temp$SYMBOL $current_desc"
	NOTIFYEND="$trend  $(get_icon "$forecast_icon") $forecast_temp$SYMBOL"
	MESSAGE="$(get_icon "$current_icon") $current_temp$SYMBOL $current_desc  $trend  $(get_icon "$forecast_icon") $forecast_temp$SYMBOL"
	notify-send "$NOTIFY"$'\n' "$NOTIFYEND"
	echo tooltip:$MESSAGE 
	echo icon:$(get_png "$forecast_icon")
	
	
fi

sleep 200

$HOME/.config/i3status/i3status_scripts/openweathermap-forecast.sh 
