import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [WeatherInfo]
    let name: String
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
        }
    }
    
    struct WeatherInfo: Codable {
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    func toWeather() -> Weather {
        let safeTemp = (main.temp.isNaN || main.temp.isInfinite) ? 0.0 : main.temp
        let safeFeelsLike = (main.feelsLike.isNaN || main.feelsLike.isInfinite) ? safeTemp : main.feelsLike
        let safeWindSpeed = (wind.speed.isNaN || wind.speed.isInfinite) ? 0.0 : max(0.0, wind.speed)
        let safeHumidity = max(0, min(100, main.humidity))
        
        return Weather(
            temperature: safeTemp,
            description: weather.first?.description.capitalized ?? "",
            icon: weather.first?.icon ?? "",
            location: name,
            feelsLike: safeFeelsLike,
            humidity: safeHumidity,
            windSpeed: safeWindSpeed
        )
    }
}
