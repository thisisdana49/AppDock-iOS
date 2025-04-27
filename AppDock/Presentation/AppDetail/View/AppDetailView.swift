import SwiftUI

struct AppDetailView: View {
    let appId: String
    @State private var detail: SearchResultItem?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                ProgressView()
            } else if let detail = detail {
                Text("상세 정보 호출 성공!")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("앱 이름: \(detail.trackName)")
                Text("제작사: \(detail.artistName)")
            } else if let errorMessage = errorMessage {
                Text("오류: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("상세 정보를 불러오지 못했습니다.")
            }
        }
        .onAppear {
            Task {
                await fetchDetail()
            }
        }
        .padding()
    }

    private func fetchDetail() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await APIClient.shared.lookupApp(id: appId)
            detail = response.results.first
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}