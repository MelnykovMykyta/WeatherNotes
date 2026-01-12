import Foundation
import CoreLocation

enum WeatherServiceError: LocalizedError {
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return message
        }
    }
}

class WeatherService {
    static let shared = WeatherService()
    
    private let apiKey = "7f6f56e312da56f0397f5f038588b726"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    
    private init() {}
    
    func getWeather(for city: String = "Kyiv", completion: @escaping (Result<Weather, WeatherServiceError>) -> Void) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "APPID", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "ru")
        ]
        
        guard let url = components?.url else {
            completion(.failure(.networkError("Неверный URL")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError("Нет данных от сервера")))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["message"] as? String ?? "Ошибка сервера"
                completion(.failure(.networkError(message)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(response.toWeather()))
            } catch {
                completion(.failure(.networkError("Ошибка обработки данных")))
            }
        }.resume()
    }
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double, completion: @escaping (Result<Weather, WeatherServiceError>) -> Void) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "APPID", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "ru")
        ]
        
        guard let url = components?.url else {
            completion(.failure(.networkError("Неверный URL")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError("Нет данных от сервера")))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["message"] as? String ?? "Ошибка сервера"
                completion(.failure(.networkError(message)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(response.toWeather()))
            } catch {
                completion(.failure(.networkError("Ошибка обработки данных")))
            }
        }.resume()
    }
}
