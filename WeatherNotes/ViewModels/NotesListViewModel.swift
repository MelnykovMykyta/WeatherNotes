import Foundation
import Combine

class NotesListViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let storageService = NotesStorageService.shared
    
    init() {
        loadNotes()
    }
    
    func loadNotes() {
        notes = storageService.loadNotes().sorted { $0.createdAt > $1.createdAt }
    }
    
    func deleteNote(_ note: Note) {
        storageService.deleteNote(note)
        loadNotes()
    }
    
    func refresh() {
        loadNotes()
    }
}
