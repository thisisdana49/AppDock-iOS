import SwiftUI

struct AppListRowView: View {
    let app: AppItem

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: app.iconURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.headline)
                if let date = app.downloadedAt {
                    Text(Self.format(date: date))
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("엥")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Group {
                switch app.state {
                case .get:
                    Button(action: { /* TODO: Implement download action */ }) {
                        Text("받기")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                case .downloading:
                    Button(action: { /* TODO: Implement pause action */ }) {
                        DownloadProgressCircleView(
                            progress: 1.0 - (app.remainingTime / 30.0),
                            isPaused: false
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                case .paused:
                    Button(action: { /* TODO: Implement resume action */ }) {
                        HStack(spacing: 4) {
                            Image(systemName: "icloud.and.arrow.down")
                            Text("재개")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                case .open:
                    Button(action: { /* TODO: Implement open action */ }) {
                        Text("열기")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                case .retry:
                    Button(action: { /* TODO: Implement retry action */ }) {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.vertical, 4)
    }

    private static func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d"
        return formatter.string(from: date)
    }
} 
