import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesListViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showingAddNote = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                (settingsViewModel.isDarkMode ? Color(red: 0.05, green: 0.05, blue: 0.05) : Color(.systemBackground))
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if viewModel.notes.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "note.text")
                                .font(.system(size: 64, weight: .light))
                                .foregroundColor(settingsViewModel.isDarkMode ? .white.opacity(0.3) : .gray.opacity(0.3))
                            
                            Text("Нет заметок")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(settingsViewModel.isDarkMode ? .white.opacity(0.9) : .primary)
                            
                            Text("Нажмите кнопку внизу чтобы добавить заметку")
                                .font(.system(size: 15))
                                .foregroundColor(settingsViewModel.isDarkMode ? .white.opacity(0.5) : .secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(viewModel.notes) { note in
                                    NavigationLink(destination: NoteDetailView(note: note)) {
                                        NoteRowView(note: note, isDarkMode: settingsViewModel.isDarkMode)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.deleteNote(note)
                                        } label: {
                                            Label("Удалить", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .padding(.bottom, 100)
                        }
                    }
                    
                    Button(action: { showingAddNote = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Новая заметка")
                                .font(.system(size: 17, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 34)
                }
            }
            .navigationTitle("Заметки")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(settingsViewModel.isDarkMode ? .white : .primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: settingsViewModel)
                    .onDisappear {
                        viewModel.refresh()
                    }
            }
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}

struct NoteRowView: View {
    let note: Note
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(note.text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(isDarkMode ? .white : .primary)
                    .lineLimit(2)
                
                HStack(spacing: 10) {
                    if let weather = note.weather {
                        HStack(spacing: 4) {
                            Image(systemName: weather.iconName)
                                .font(.system(size: 12))
                                .foregroundColor(isDarkMode ? .white.opacity(0.6) : .secondary)
                            Text(weather.temperatureString)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(isDarkMode ? .white.opacity(0.6) : .secondary)
                        }
                    }
                    
                    Text(formatDate(note.createdAt))
                        .font(.system(size: 12))
                        .foregroundColor(isDarkMode ? .white.opacity(0.5) : .secondary)
                }
            }
            
            Spacer()
            
            if let weather = note.weather {
                Image(systemName: weather.iconName)
                    .font(.system(size: 28))
                    .foregroundColor(isDarkMode ? .white.opacity(0.7) : .blue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isDarkMode ? Color(white: 0.12) : Color(.secondarySystemBackground))
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}

#Preview {
    NotesListView()
}
