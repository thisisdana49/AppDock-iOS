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
                Text(app.developer)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(app.version)
                    .font(.caption2)
                    .foregroundColor(.gray)
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
} 