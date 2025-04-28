import SwiftUI

struct DownloadProgressView: View {
    let remainingTime: Int
    let totalTime: Int
    let isPaused: Bool
    
    private var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1.0 - Double(remainingTime) / Double(totalTime)
    }
    
    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(DownloadProgressViewStyle(isPaused: isPaused))
            .animation(.easeInOut, value: progress)
    }
}

struct DownloadProgressViewStyle: ProgressViewStyle {
    let isPaused: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
                
                // Progress
                RoundedRectangle(cornerRadius: 2)
                    .fill(isPaused ? Color.orange : Color.blue)
                    .frame(width: geometry.size.width * (configuration.fractionCompleted ?? 0), height: 4)
                    .animation(.easeInOut, value: configuration.fractionCompleted)
            }
        }
        .frame(height: 4)
    }
}

#Preview {
    VStack(spacing: 20) {
        DownloadProgressView(remainingTime: 30, totalTime: 60, isPaused: false)
        DownloadProgressView(remainingTime: 15, totalTime: 60, isPaused: true)
        DownloadProgressView(remainingTime: 0, totalTime: 60, isPaused: false)
    }
    .padding()
} 