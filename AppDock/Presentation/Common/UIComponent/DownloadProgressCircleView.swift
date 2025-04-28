import SwiftUI

struct DownloadProgressCircleView: View {
    let progress: Double
    let isPaused: Bool
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color(.systemGray4), lineWidth: 3)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // Pause icon
            Image(systemName: "pause.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.blue)
        }
        .frame(width: 36, height: 36)
    }
}

#Preview {
    HStack(spacing: 20) {
        DownloadProgressCircleView(progress: 0.3, isPaused: false)
        DownloadProgressCircleView(progress: 0.7, isPaused: true)
    }
    .padding()
} 