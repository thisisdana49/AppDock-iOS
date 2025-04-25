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
            .init(id: "1", name: "Timer 앱", developer: "AppDock", iconURL: nil, state: .get),
            .init(id: "2", name: "가짜 노트", developer: "AppDock", iconURL: nil, state: .get)
        ]
        dummyApps.forEach { appState.add($0) }
    }
}
