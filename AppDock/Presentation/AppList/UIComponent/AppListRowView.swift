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
            Text("열기")
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
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
