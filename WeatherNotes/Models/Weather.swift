import Foundation

struct Weather: Codable {
    let temperature: Double
    let description: String
    let icon: String
    let location: String
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    
    private var safeTemperature: Double {
        (temperature.isNaN || temperature.isInfinite) ? 0.0 : temperature
    }
    
    private var safeFeelsLike: Double {
        (feelsLike.isNaN || feelsLike.isInfinite) ? safeTemperature : feelsLike
    }
    
    private var safeWindSpeed: Double {
        (windSpeed.isNaN || windSpeed.isInfinite) ? 0.0 : max(0.0, windSpeed)
    }
    
    var isValid: Bool {
        !temperature.isNaN && !temperature.isInfinite &&
        !feelsLike.isNaN && !feelsLike.isInfinite &&
        !windSpeed.isNaN && !windSpeed.isInfinite &&
        humidity >= 0 && humidity <= 100
    }
    
    var temperatureString: String {
        String(format: "%.0f°", safeTemperature)
    }
    
    var feelsLikeString: String {
        String(format: "%.0f°", safeFeelsLike)
    }
    
    var windSpeedString: String {
        String(format: "%.1f м/с", safeWindSpeed)
    }
    
    var iconName: String {
        switch icon {
        case "01d", "01n": return "sun.max.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d", "10n": return "cloud.sun.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "cloud.snow.fill"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "sun.max.fill"
        }
    }
}
