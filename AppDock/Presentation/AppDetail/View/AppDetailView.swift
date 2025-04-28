//
//  AppDetailView.swift
//  AppDock
//
//  Created by 조다은 on 4/27/25.
//

import SwiftUI

struct ScreenshotItem: Identifiable, Equatable {
    let url: String
    var id: String { url }
}

struct AppDetailView: View {
    let appId: String
    @EnvironmentObject var appState: AppStateManager
    @State private var detail: SearchResultItem?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showFullReleaseNotes = false
    @State private var showCarousel = false
    @State private var carouselStartIndex = 0
    
    // 앱 상태 동기화: AppStateManager에서 최신 AppItem을 가져옴
    var syncedApp: AppItem? {
        appState.apps.first(where: { $0.id == appId })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    ProgressView()
                } else if let detail = detail {
                    // 앱 아이콘, 이름, 열기/다운로드 버튼, 남은 시간
                    HStack(alignment: .center, spacing: 16) {
                        AsyncImage(url: URL(string: detail.artworkUrl100 ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(detail.trackName)
                                .font(.title2)
                                .bold()
                            Text(detail.artistName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if let app = syncedApp {
                            VStack {
                                switch app.state {
                                case .get:
                                    Button("받기") {
                                        AppStateManager.shared.transition(appID: app.id, action: .tapDownloadButton)
                                    }
                                    .font(.subheadline.bold())
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemGray6))
                                    .clipShape(Capsule())
                                case .downloading:
                                    Button(action: {
                                        AppStateManager.shared.transition(appID: app.id, action: .tapDownloadButton)
                                    }) {
                                        DownloadProgressCircleView(
                                            progress: 1.0 - (app.remainingTime / 30.0),
                                            isPaused: false
                                        )
                                    }
                                case .paused:
                                    Button(action: {
                                        AppStateManager.shared.transition(appID: app.id, action: .tapDownloadButton)
                                    }) {
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
                                case .open:
                                    Button("열기") {
                                        AppStateManager.shared.transition(appID: app.id, action: .tapDownloadButton)
                                    }
                                    .font(.subheadline.bold())
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemGray6))
                                    .clipShape(Capsule())
                                case .retry:
                                    Button(action: {
                                        AppStateManager.shared.transition(appID: app.id, action: .tapDownloadButton)
                                    }) {
                                        Image(systemName: "icloud.and.arrow.down")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                    }
                                }
                            }
                        } else {
                            Button("받기") {}
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                        }
                    }

                    // 앱 정보 가로 스크롤
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            InfoColumn(title: "버전", value: detail.version ?? "-")
                            InfoColumn(title: "연령", value: String(detail.averageUserRating ?? 0.0))
                            InfoColumn(title: "카테고리", value: detail.primaryGenreName ?? "-")
                            InfoColumn(title: "개발자", value: detail.sellerName ?? "-")
                        }
                        .padding(.vertical, 8)
                    }

                    Divider()

                    // 새로운 소식 (릴리즈 노트)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("새로운 소식")
                            .font(.headline)
                        if let notes = detail.releaseNotes, !notes.isEmpty {
                            Text(notes)
                                .font(.body)
                                .lineLimit(showFullReleaseNotes ? nil : 3)
                            if !showFullReleaseNotes && notes.count > 60 {
                                Button("더보기") {
                                    showFullReleaseNotes = true
                                }
                                .font(.caption)
                            }
                        } else {
                            Text("릴리즈 노트가 없습니다.")
                                .foregroundColor(.gray)
                        }
                    }

                    Divider()

                    // 미리보기(스크린샷)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("미리 보기")
                            .font(.headline)
                        let screenshots = (detail.screenshotUrls ?? []).map { ScreenshotItem(url: $0) }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(screenshots.enumerated()), id: \ .element.id) { idx, item in
                                    AsyncImage(url: URL(string: item.url)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.1)
                                    }
                                    .frame(width: 180, height: 360)
                                    .clipped()
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        carouselStartIndex = idx
                                        showCarousel = true
                                    }
                                }
                            }
                        }
                    }
                } else if let errorMessage = errorMessage {
                    Text("오류: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("상세 정보를 불러오지 못했습니다.")
                }
            }
            .padding()
        }
        .onAppear {
            Task { await fetchDetail() }
        }
        // 스크린샷 Carousel 전체화면 뷰
        .fullScreenCover(isPresented: $showCarousel) {
            if let screenshots = detail?.screenshotUrls?.map({ ScreenshotItem(url: $0) }), !screenshots.isEmpty {
                ScreenshotCarouselView(
                    screenshots: screenshots,
                    initialIndex: carouselStartIndex,
                    isPresented: $showCarousel
                )
            }
        }
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

// 앱 정보 컬럼 뷰
struct InfoColumn: View {
    let title: String
    let value: String
    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(minWidth: 60)
    }
}

// 스크린샷 전체화면 뷰
struct ScreenshotFullScreenView: View, Identifiable {
    let imageURL: String
    let onDismiss: () -> Void
    var id: String { imageURL }
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } placeholder: {
                ProgressView()
            }
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
