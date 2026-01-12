import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
    let createdAt: Date
    let weather: Weather?
    
    init(id: UUID = UUID(), text: String, createdAt: Date = Date(), weather: Weather? = nil) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.weather = weather
    }
}
