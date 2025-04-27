//
//  SearchViewModel.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var apps: [AppItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let appState: AppStateManager
    private let downloadUseCase: AppDownloadUseCase

    init(appState: AppStateManager = .shared,
         downloadUseCase: AppDownloadUseCase = DefaultAppDownloadUseCase()) {
        self.appState = appState
        self.downloadUseCase = downloadUseCase

        // 앱 상태 바인딩
        appState.$apps
            .assign(to: &$apps)
    }

    func didTapDownloadButton(appID: String) {
        downloadUseCase.handleUserAction(appID: appID)
    }

    func injectDummyApps() {
        let dummyApps: [AppItem] = [
            .init(id: "1", name: "Timer 앱", developer: "AppDock", iconURL: nil, state: .get, remainingTime: 30),
            .init(id: "2", name: "가짜 노트", developer: "AppDock", iconURL: nil, state: .get, remainingTime: 30)
        ]
        dummyApps.forEach { appState.add($0) }
    }

    func searchApps(term: String) {
        Task {
            do {
                isLoading = true
                errorMessage = nil

                // 🔥 검색 시작할 때 기존 앱 리스트 초기화
                appState.reset()

                let response = try await APIClient.shared.searchApps(term: term)

                let appItems: [AppItem] = response.results.map { item in
                    AppItem(
                        id: String(item.trackId),
                        name: item.trackName,
                        developer: item.artistName,
                        iconURL: item.artworkUrl100.flatMap { URL(string: $0) },
                        state: .get,
                        remainingTime: 30
                    )
                }

                appItems.forEach { appState.add($0) }

            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
