import Foundation
import CoreLocation

enum LocationServiceError: LocalizedError {
    case permissionDenied
    case locationUnavailable
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Доступ к геолокации запрещен. Разрешите доступ в настройках приложения."
        case .locationUnavailable:
            return "Не удалось определить местоположение. Проверьте настройки геолокации."
        case .unknown:
            return "Неизвестная ошибка определения местоположения"
        }
    }
}

class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocation, LocationServiceError>) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation(completion: @escaping (Result<CLLocation, LocationServiceError>) -> Void) {
        locationCompletion = completion
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            completion(.failure(.permissionDenied))
            locationCompletion = nil
        @unknown default:
            completion(.failure(.unknown))
            locationCompletion = nil
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationCompletion?(.failure(.locationUnavailable))
            locationCompletion = nil
            return
        }
        
        locationCompletion?(.success(location))
        locationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка геолокации: \(error.localizedDescription)")
        locationCompletion?(.failure(.locationUnavailable))
        locationCompletion = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            locationCompletion?(.failure(.permissionDenied))
            locationCompletion = nil
        default:
            break
        }
    }
}
