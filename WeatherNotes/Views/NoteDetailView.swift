import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @StateObject private var viewModel: NoteDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    init(note: Note) {
        self.note = note
        _viewModel = StateObject(wrappedValue: NoteDetailViewModel(note: note))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(note.text)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(viewModel.formattedFullDate)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                if let weather = note.weather {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Погода")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                        
                        VStack(spacing: 0) {
                            HStack(alignment: .center, spacing: 16) {
                                Image(systemName: weather.iconName)
                                    .font(.system(size: 56))
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(weather.temperatureString)
                                        .font(.system(size: 42, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Text(weather.description)
                                        .font(.system(size: 16))
                                        .foregroundColor(.secondary)
                                    
                                    Text(weather.location)
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary.opacity(0.8))
                                }
                                
                                Spacer()
                            }
                            .padding(16)
                            
                            Divider()
                            
                            VStack(spacing: 14) {
                                WeatherDetailRow(
                                    icon: "thermometer",
                                    title: "Ощущается как",
                                    value: weather.feelsLikeString
                                )
                                
                                WeatherDetailRow(
                                    icon: "humidity",
                                    title: "Влажность",
                                    value: "\(weather.humidity)%"
                                )
                                
                                WeatherDetailRow(
                                    icon: "wind",
                                    title: "Скорость ветра",
                                    value: weather.windSpeedString
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .padding(.horizontal, 16)
                    }
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "cloud.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("Погода недоступна")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
    }
}

struct WeatherDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: Note(
            text: "Пробежка в парке",
            createdAt: Date(),
            weather: Weather(
                temperature: 22,
                description: "Ясно",
                icon: "01d",
                location: "Kyiv",
                feelsLike: 24,
                humidity: 65,
                windSpeed: 3.5
            )
        ))
    }
}
