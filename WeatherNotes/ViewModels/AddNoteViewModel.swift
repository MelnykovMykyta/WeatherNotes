import Foundation
import Combine
import CoreLocation

class AddNoteViewModel: ObservableObject {
    @Published var noteText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSaving = false
    
    private let weatherService = WeatherService.shared
    private let storageService = NotesStorageService.shared
    private let locationService = LocationService.shared
    
    func saveNote(completion: @escaping (Bool) -> Void) {
        isLoading = true
        isSaving = true
        errorMessage = nil
        
        locationService.requestLocation { [weak self] locationResult in
            guard let self = self else { return }
            
            switch locationResult {
            case .success(let location):
                self.weatherService.getWeatherByCoordinates(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                ) { weatherResult in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.handleWeatherResult(weatherResult, completion: completion)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    let note = Note(
                        text: self.noteText.trimmingCharacters(in: .whitespacesAndNewlines),
                        createdAt: Date(),
                        weather: nil
                    )
                    self.storageService.addNote(note)
                    self.errorMessage = "Заметка сохранена, но погода не получена: \(error.localizedDescription)"
                    self.isSaving = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        completion(true)
                    }
                }
            }
        }
    }
    
    private func handleWeatherResult(_ result: Result<Weather, WeatherServiceError>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let weather):
            let note = Note(
                text: self.noteText.trimmingCharacters(in: .whitespacesAndNewlines),
                createdAt: Date(),
                weather: weather
            )
            self.storageService.addNote(note)
            self.noteText = ""
            self.isSaving = false
            completion(true)
            
        case .failure(let error):
            let note = Note(
                text: self.noteText.trimmingCharacters(in: .whitespacesAndNewlines),
                createdAt: Date(),
                weather: nil
            )
            self.storageService.addNote(note)
            self.errorMessage = "Заметка сохранена, но погода не получена: \(error.localizedDescription)"
            self.isSaving = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                completion(true)
            }
        }
    }
}
