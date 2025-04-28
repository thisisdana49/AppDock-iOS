//
//  AppSearchResultRowView.swift
//  AppDock
//
//  Created by 조다은 on 4/27/25.
//

import SwiftUI

struct AppSearchResultRowView: View {
    let app: AppItem
    let onDownload: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                // 앱 아이콘
                AsyncImage(url: app.iconURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    // 앱 제목
                    Text(app.name)
                        .font(.headline)
                        .lineLimit(1)
                    // 부제목(제작사)
                    Text(app.developer)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(.leading, 4)
                Spacer()
                // 다운로드 버튼 UI 개선
                VStack {
                    switch app.state {
                    case .get:
                        Button(action: { onDownload() }) {
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
                        Button(action: { onDownload() }) {
                            DownloadProgressCircleView(
                                progress: 1.0 - (app.remainingTime / 30.0),
                                isPaused: false
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    case .paused:
                        Button(action: { onDownload() }) {
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
                        Button(action: { onDownload() }) {
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
                        Button(action: { onDownload() }) {
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
            // 설명
            HStack(spacing: 8) {
                Text(app.minimumOSVersion)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Text(app.sellerName)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Text(app.primaryGenreName)  // TODO: 장르 한국어로 매핑
                    .foregroundColor(.gray)
                    .font(.caption)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            // 스크린샷
            if app.state != .open {
                GeometryReader { geometry in
                    let cellWidth = geometry.size.width
                    let screenshotWidth = (cellWidth - 16) / 3
                    let screenshots = Array(app.screenshotURLs.prefix(3))
                    let hasScreenshots = !screenshots.isEmpty
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            if hasScreenshots {
                                ForEach(screenshots, id: \.self) { url in
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.1)
                                    }
                                    .frame(width: screenshotWidth, height: screenshotWidth * 2)
                                    .clipped()
                                    .cornerRadius(10)
                                }
                            } else {
                                ForEach(0..<3) { _ in
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screenshotWidth, height: screenshotWidth * 2)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .frame(height: screenshotWidth * 2)
                }
                .frame(height: 220)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    AppSearchResultRowView()
//}
