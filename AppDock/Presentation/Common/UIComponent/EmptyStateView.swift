import SwiftUI

struct EmptyStateView: View {
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    EmptyStateView(
        message: "다운로드한 앱이 없습니다.\n앱스토어에서 앱을 검색하고 다운로드해보세요.",
        icon: "square.and.arrow.down"
    )
} 