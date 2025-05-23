//
//  SearchViewModel.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation
import Combine
import Network

final class SearchViewModel: ObservableObject {
    @Published var searchResults: [AppItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let appState: AppStateManager
    private let downloadUseCase: AppDownloadUseCase
    private var cancellables = Set<AnyCancellable>()

    init(appState: AppStateManager = .shared,
         downloadUseCase: AppDownloadUseCase = DefaultAppDownloadUseCase()) {
        self.appState = appState
        self.downloadUseCase = downloadUseCase
        
        // AppStateManager의 상태 변경 구독
        appState.$apps
            .sink { [weak self] updatedApps in
                guard let self = self else { return }
                // searchResults의 앱 상태를 업데이트 및 삭제 반영
                self.searchResults = self.searchResults.compactMap { result in
                    if let updated = updatedApps.first(where: { $0.id == result.id }) {
                        return updated
                    } else if self.appState.apps.contains(where: { $0.id == result.id }) == false && result.state == .open {
                        // 앱이 삭제되어 .retry 등으로 바뀐 경우, 검색 결과에서 상태만 갱신
                        var modified = result
                        if let latest = self.appState.apps.first(where: { $0.id == result.id }) {
                            modified = latest
                        } else {
                            modified = result.copyWith(state: .retry)
                        }
                        return modified
                    } else {
                        return result
                    }
                }
            }
            .store(in: &cancellables)

        NetworkMonitor.shared.$isConnected
            .sink { [weak self] isConnected in
                if !isConnected {
                    self?.errorMessage = "네트워크 연결이 없습니다. 인터넷 상태를 확인해주세요."
                }
            }
            .store(in: &cancellables)
    }

    func didTapDownloadButton(appID: String) {
        guard let app = searchResults.first(where: { $0.id == appID }) else { return }
        
        // 먼저 AppStateManager에 앱 추가
        appState.add(app)
        
        // 그 다음 상태 전이 실행
        downloadUseCase.handleUserAction(appID: appID)
    }

    func searchApps(term: String) {
        searchResults.removeAll()
        
        Task {
            do {
                isLoading = true
                errorMessage = nil

                let response = try await APIClient.shared.searchApps(term: term)

                let appItems: [AppItem] = response.results.map { item in
                    // 이미 다운로드된 앱인 경우 해당 상태로 설정
                    if let existingApp = appState.apps.first(where: { $0.id == String(item.trackId) }) {
                        return existingApp
                    }
                    
                    return AppItem(
                        id: String(item.trackId),
                        name: item.trackName,
                        developer: item.artistName,
                        iconURL: item.artworkUrl100?.isEmpty == false ? URL(string: item.artworkUrl100!) : (item.artworkUrl512?.isEmpty == false ? URL(string: item.artworkUrl512!) : nil),
                        screenshotURLs: (item.screenshotUrls ?? []).compactMap { URL(string: $0) },
                        description: item.description ?? "",
                        minimumOSVersion: item.minimumOsVersion ?? "",
                        sellerName: item.sellerName ?? "",
                        primaryGenreName: item.primaryGenreName ?? "",
                        genres: item.genres ?? [],
                        version: item.version ?? "",
                        releaseNotes: item.releaseNotes,
                        trackViewUrl: item.trackViewUrl.flatMap { URL(string: $0) },
                        price: item.price ?? 0,
                        formattedPrice: item.formattedPrice,
                        averageUserRating: item.averageUserRating,
                        contentAdvisoryRating: item.contentAdvisoryRating,
                        state: .get,
                        remainingTime: 30
                    )
                }

                self.searchResults = appItems

            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
