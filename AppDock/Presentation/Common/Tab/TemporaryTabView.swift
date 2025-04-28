import SwiftUI

struct TemporaryTabView: View {
    let title: String
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(title)
                .font(.largeTitle)
                .bold()
            Text("\(title) 뷰를 준비중입니다.")
                .font(.title3)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview {
    TemporaryTabView(title: "투데이")
} 