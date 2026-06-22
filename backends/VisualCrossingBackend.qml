import QtQuick 2.6
import "BackendUtils.js" as BackendUtils
import "GeoNames.js" as GeoNames
import "WeatherTypeDescriptions.js" as WeatherTypeDescriptions
import "VisualCrossingTranslations.js" as Translations

QtObject {
    readonly property string visualCrossingApi: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"

    function providerId() {
        return "visual_crossing"
    }

    function providerTitle() {
        return Translations.translate("title", getLanguage())
    }

    function requiresApiKey() {
        return true
    }

    function apiKeyInstructions() {
        return Translations.translate("instructions", getLanguage())
                .arg("https://www.visualcrossing.com/weather-api")
    }

    function attributionText() {
        return Translations.translate("attribution", getLanguage())
                .arg("<a href='https://www.visualcrossing.com/'>")
                .arg("</a>")
    }

    function shortAttributionText() {
        return Translations.translate("short-attribution", getLanguage())
    }

    function locationSearchAttributionText() {
        //% "Location search by %1GeoNames%2."
        return qsTrId("weather-la-geonames-attribution")
                .arg("<a href='https://www.geonames.org/'>")
                .arg("</a>")
    }

    function maxPrecision() {
        return 4
    }

    function canLoadWeather(weather) {
        return weather.latitude !== undefined && weather.longitude !== undefined &&
               (Math.abs(weather.latitude) > 0.0001 || Math.abs(weather.longitude) > 0.0001)
    }

    function fetchToken(weatherRequest, apiKey) {
        weatherRequest.token = apiKey ? apiKey : ""
        return true
    }

    function requestHeaders() {
        return {
            "Accept": "application/json",
            "User-Agent": "Sailfish Weather/1.0 (+https://github.com/juanro49/harbour-weather-backend-visualcrossing)"
        }
    }

    function getLanguage() {
        var locale = Qt.locale().name
        if (locale.length >= 2) {
            return locale.substring(0, 2).toLowerCase()
        }
        return "en"
    }

    function currentWeatherUrl(weather) {
        return visualCrossingApi + weather.latitude + "," + weather.longitude
            + "?unitGroup=metric&include=current,days"
            + "&lang=" + getLanguage() + "&contentType=json&key="
    }

    function latestObservationUrl(weather) {
        return currentWeatherUrl(weather)
    }

    function forecastUrl(weather, isHourly) {
        return visualCrossingApi + weather.latitude + "," + weather.longitude
            + "?unitGroup=metric&include=days,hours"
            + "&lang=" + getLanguage() + "&contentType=json&key="
    }

    function searchLocationUrl(filter, language) {
        var url = GeoNames.searchLocationUrl(filter, language)
        // El framework siempre concatena el 'token' (API Key) al final de esta URL.
        // GeoNames usa 'username=xxxx' y no reconoce la clave de Visual Crossing.
        // Forzamos que la URL termine en '&token=' para que la clave se añada ahí
        // y no rompa el parámetro 'username'.
        if (url.indexOf("&token=") === -1) {
            url += "&token="
        }
        return url
    }

    function handleCurrentWeatherResult(result) {
        if (!result || !result.currentConditions) {
            return undefined
        }

        var current = result.currentConditions
        var weather = getWeatherData(current)
        weather.timestamp = new Date(current.datetimeEpoch * 1000)
        weather.temperature = current.temp
        weather.feelsLikeTemperature = current.feelslike

        if (result.days && result.days.length > 0) {
            var day = result.days[0]
            var range = day.tempmax - day.tempmin
            if (range > 0) {
                weather.relativeTemperature = (current.temp - day.tempmin) / range
            } else {
                weather.relativeTemperature = 0.5
            }
        }

        return weather
    }

    function handleForecastResult(result, hourly, visibleCount, minimumHourlyRange) {
        if (!result || !result.days || result.days.length === 0) {
            return undefined
        }

        var weatherData = []
        if (hourly) {
            for (var d = 0; d < Math.min(result.days.length, 2); d++) {
                var day = result.days[d]
                if (!day.hours) continue
                for (var h = 0; h < day.hours.length; h++) {
                    var hourData = day.hours[h]
                    var weather = getWeatherData(hourData)
                    weather.timestamp = new Date(hourData.datetimeEpoch * 1000)
                    weather.temperature = hourData.temp
                    weatherData.push(weather)
                }
            }

            var now = Date.now()
            weatherData = weatherData.filter(function(w) {
                return w.timestamp.getTime() > now - 3600000
            })

            return BackendUtils.normalizeHourlyTemperatures(
                        weatherData, visibleCount, minimumHourlyRange, true)
        } else {
            for (var i = 0; i < result.days.length; i++) {
                var dayData = result.days[i]
                var dailyWeather = getWeatherData(dayData)
                dailyWeather.timestamp = new Date(dayData.datetimeEpoch * 1000)
                dailyWeather.accumulatedPrecipitation = dayData.precip || 0
                dailyWeather.maximumWindSpeed = Math.round(dayData.windspeed || 0)
                dailyWeather.windDirection = dayData.winddir || 0
                dailyWeather.high = Math.floor(dayData.tempmax)
                dailyWeather.low = Math.round(dayData.tempmin)

                weatherData.push(dailyWeather)
            }
            return weatherData
        }
    }

    function handleSearchLocationResult(result) {
        return GeoNames.handleSearchLocationResult(result)
    }

    function handleObservationResult(result) {
        if (result && result.currentConditions && result.currentConditions.stations && result.currentConditions.stations.length > 0 && result.stations) {
            var stationId = result.currentConditions.stations[0]
            var stationData = result.stations[stationId]
            if (stationData) {
                return stationData.name || stationId
            }
        }
        return ""
    }

    function externalUrl(weather) {
        return "https://www.visualcrossing.com/weather-forecast/" + weather.latitude + "," + weather.longitude + "/"
    }

    function providerImage() {
        return "image://theme/visual-crossing?"
    }

    function smallProviderImage() {
        return "image://theme/visual-crossing-small?"
    }

    function weatherTypeFromVisualCrossing(icon, isDay) {
        var timePrefix = isDay ? "d" : "n"

        switch (icon) {
            case "snow":
                return timePrefix + "312"
            case "snow-showers-day":
            case "snow-showers-night":
                return timePrefix + "322"
            case "thunder-rain":
            case "thunder-showers-day":
            case "thunder-showers-night":
                return timePrefix + "440"
            case "rain":
                return timePrefix + "430"
            case "showers-day":
            case "showers-night":
                return timePrefix + "320"
            case "fog":
                return timePrefix + "600"
            case "wind":
                return timePrefix + "400"
            case "cloudy":
                return timePrefix + "300"
            case "partly-cloudy-day":
            case "partly-cloudy-night":
                return timePrefix + "200"
            case "clear-day":
            case "clear-night":
                return timePrefix + "000"
            case "sleet":
                return timePrefix + "311"
            case "freezing-rain":
                return timePrefix + "410"
            default:
                return timePrefix + "300"
        }
    }

    function getWeatherData(data) {
        var icon = data.icon || ""
        var isDay = icon.indexOf("-day") >= 0 || icon === "clear-day" || icon === ""
        if (icon.indexOf("-night") >= 0) isDay = false

        var symbol = weatherTypeFromVisualCrossing(icon, isDay)

        return {
            "description": data.conditions || WeatherTypeDescriptions.description(symbol),
            "weatherType": symbol,
            "cloudiness": data.cloudcover !== undefined ? data.cloudcover : 0
        }
    }
}
