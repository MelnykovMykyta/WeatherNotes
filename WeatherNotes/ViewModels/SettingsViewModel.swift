import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    @Published var showingClearAlert = false
    
    func clearAllData() {
        NotesStorageService.shared.saveNotes([])
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
}
