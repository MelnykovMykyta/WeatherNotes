import SwiftUI

struct AddNoteView: View {
    @ObservedObject var viewModel: NotesListViewModel
    @StateObject private var addNoteViewModel = AddNoteViewModel()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                (isDarkMode ? Color(red: 0.05, green: 0.05, blue: 0.05) : Color(.systemBackground))
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Новая заметка")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Запишите что-то важное")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    
                    ZStack(alignment: .topLeading) {
                        if addNoteViewModel.noteText.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "pencil.line")
                                        .font(.system(size: 18))
                                        .foregroundColor(.secondary.opacity(0.5))
                                    Text("Что вы хотите запомнить?")
                                        .font(.system(size: 18))
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                                Text("Начните вводить текст...")
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary.opacity(0.4))
                                    .padding(.leading, 26)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                        
                        TextEditor(text: $addNoteViewModel.noteText)
                            .font(.system(size: 18, weight: .regular))
                            .lineSpacing(8)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .focused($isTextFieldFocused)
                            .tint(.blue)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isDarkMode ? Color(white: 0.12) : Color.white)
                            .shadow(
                                color: isDarkMode ? .black.opacity(0.3) : .black.opacity(0.08),
                                radius: isDarkMode ? 10 : 20,
                                x: 0,
                                y: isDarkMode ? 4 : 8
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isTextFieldFocused ? Color.blue.opacity(0.5) : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .padding(.horizontal, 20)
                    .animation(.easeInOut(duration: 0.2), value: isTextFieldFocused)
                    
                    if addNoteViewModel.isLoading {
                        HStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(0.9)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Определение местоположения...")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.primary)
                                Text("Получение данных о погоде")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isDarkMode ? Color.blue.opacity(0.15) : Color.blue.opacity(0.08))
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if let errorMessage = addNoteViewModel.errorMessage {
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 18))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Заметка сохранена")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.primary)
                                Text(errorMessage)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isDarkMode ? Color.orange.opacity(0.2) : Color.orange.opacity(0.1))
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    Spacer()
                    
                    Button(action: {
                        addNoteViewModel.saveNote { success in
                            if success {
                                viewModel.refresh()
                                dismiss()
                            }
                        }
                    }) {
                        HStack(spacing: 10) {
                            if addNoteViewModel.isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                                Text("Сохранение...")
                                    .font(.system(size: 17, weight: .semibold))
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                Text("Сохранить заметку")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundColor(.white)
                        .background(
                            Group {
                                if addNoteViewModel.noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || addNoteViewModel.isSaving {
                                    Color.gray.opacity(0.4)
                                } else {
                                    LinearGradient(
                                        colors: [Color.blue, Color.blue.opacity(0.85)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .cornerRadius(16)
                        .shadow(
                            color: addNoteViewModel.noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || addNoteViewModel.isSaving
                                ? .clear
                                : .blue.opacity(0.3),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                    }
                    .disabled(addNoteViewModel.noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || addNoteViewModel.isSaving)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: addNoteViewModel.isSaving)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: addNoteViewModel.noteText.isEmpty)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTextFieldFocused = true
                }
            }
        }
    }
}

#Preview {
    AddNoteView(viewModel: NotesListViewModel())
}
