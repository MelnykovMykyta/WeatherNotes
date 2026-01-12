import Foundation

class NotesStorageService {
    static let shared = NotesStorageService()
    private let notesKey = "saved_notes"
    
    private init() {}
    
    func saveNotes(_ notes: [Note]) {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    func loadNotes() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: notesKey),
              let notes = try? JSONDecoder().decode([Note].self, from: data) else {
            return []
        }
        return notes
    }
    
    func addNote(_ note: Note) {
        var notes = loadNotes()
        notes.insert(note, at: 0)
        saveNotes(notes)
    }
    
    func deleteNote(_ note: Note) {
        var notes = loadNotes()
        notes.removeAll { $0.id == note.id }
        saveNotes(notes)
    }
}
