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
    @State private var showFullDescription = false
    
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
                                .lineLimit(2)
                                .truncationMode(.tail)
                            Text(detail.artistName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                                .truncationMode(.tail)
                            if let app = syncedApp {
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
                            } else {
                                Button("받기") {
                                    let newApp = AppItem(
                                        id: appId,
                                        name: detail.trackName,
                                        developer: detail.artistName,
                                        iconURL: detail.artworkUrl100?.isEmpty == false ? URL(string: detail.artworkUrl100!) : (detail.artworkUrl512?.isEmpty == false ? URL(string: detail.artworkUrl512!) : nil),
                                        screenshotURLs: (detail.screenshotUrls ?? []).compactMap { URL(string: $0) },
                                        description: detail.description ?? "",
                                        minimumOSVersion: detail.minimumOsVersion ?? "",
                                        sellerName: detail.sellerName ?? "",
                                        primaryGenreName: detail.primaryGenreName ?? "",
                                        genres: detail.genres ?? [],
                                        version: detail.version ?? "",
                                        releaseNotes: detail.releaseNotes,
                                        trackViewUrl: detail.trackViewUrl.flatMap { URL(string: $0) },
                                        price: detail.price ?? 0,
                                        formattedPrice: detail.formattedPrice,
                                        averageUserRating: detail.averageUserRating,
                                        contentAdvisoryRating: detail.contentAdvisoryRating,
                                        state: .get,
                                        remainingTime: 30
                                    )
                                    appState.add(newApp)
                                    AppStateManager.shared.transition(appID: appId, action: .tapDownloadButton)
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    
                    // 앱 정보 가로 스크롤
                    
                    let columnWidth = UIScreen.main.bounds.width / 3.33
                    Divider()
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            InfoColumn(title: "버전", value: detail.version ?? "-")
                                .frame(width: columnWidth)
                            Divider()
                            InfoColumn(title: "연령", value: String(detail.averageUserRating ?? 0.0))
                                .frame(width: columnWidth)
                            Divider()
                            InfoColumn(title: "카테고리", value: detail.primaryGenreName ?? "-")
                                .frame(width: columnWidth)
                            Divider()
                            InfoColumn(title: "개발자", value: detail.sellerName ?? "-")
                                .frame(width: columnWidth)
                        }
                        .frame(width: columnWidth * 4)
                    }
                    .frame(width: columnWidth * 3 + columnWidth / 3, height: 40)
                    Divider()
                        .padding(.horizontal)
                    
                    
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
                    .padding(.horizontal)
                    
                    
                    // 미리보기(스크린샷)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("미리 보기")
                            .font(.headline)
                            .padding(.leading)
                        let screenshots = (detail.screenshotUrls ?? []).map { ScreenshotItem(url: $0) }
                        GeometryReader { geometry in
                            let screenshotWidth = geometry.size.width / 1.8
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
                                        .frame(width: screenshotWidth, height: screenshotWidth * 2)
                                        .clipped()
                                        .cornerRadius(4)
                                        .onTapGesture {
                                            carouselStartIndex = idx
                                            showCarousel = true
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .frame(height: (UIScreen.main.bounds.width / 1.6) * 2)
                        // 앱 설명 추가
                        if let desc = detail.description, !desc.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(desc)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                    .padding(.top, 8)
                                    .lineLimit(showFullDescription ? nil : 3)
                                if !showFullDescription && desc.count > 60 {
                                    Button("더보기") {
                                        showFullDescription = true
                                    }
                                    .font(.caption)
                                    .padding(.horizontal)
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
                    isPresented: $showCarousel,
                    app: syncedApp,
                    onDownload: {
                        if let app = syncedApp {
                            AppStateManager.shared.transition(appID: app.id, action: .tapDownloadButton)
                        }
                    }
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
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
            Text(value)
                .font(.headline)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
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
