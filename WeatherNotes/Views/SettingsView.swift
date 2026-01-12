import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        Text("Тема")
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        Picker("", selection: $viewModel.isDarkMode) {
                            Text("Светлая").tag(false)
                            Text("Темная").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 140)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Внешний вид")
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.showingClearAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            
                            Text("Очистить все данные")
                                .foregroundColor(.red)
                        }
                    }
                } header: {
                    Text("Данные")
                } footer: {
                    Text("Это действие удалит все ваши заметки без возможности восстановления")
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Назад")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .alert("Очистить все данные?", isPresented: $viewModel.showingClearAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Очистить", role: .destructive) {
                    viewModel.clearAllData()
                    dismiss()
                }
            } message: {
                Text("Все ваши заметки будут удалены. Это действие нельзя отменить.")
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
