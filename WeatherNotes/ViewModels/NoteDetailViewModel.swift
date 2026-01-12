import Foundation

class NoteDetailViewModel: ObservableObject {
    let note: Note
    
    init(note: Note) {
        self.note = note
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: note.createdAt)
    }
    
    var formattedFullDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: note.createdAt)
    }
}
