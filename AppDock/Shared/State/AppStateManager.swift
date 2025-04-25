//
//  AppStateManager.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation
import Combine

final class AppStateManager: ObservableObject {
    static let shared = AppStateManager()

    @Published var apps: [AppItem] = []

    private init() {}

    func update(_ app: AppItem) {
        guard let index = apps.firstIndex(where: { $0.id == app.id }) else { return }
        apps[index] = app
    }

    func add(_ app: AppItem) {
        if !apps.contains(where: { $0.id == app.id }) {
            apps.append(app)
        }
    }

    func remove(_ app: AppItem) {
        apps.removeAll { $0.id == app.id }
    }

    func reset() {
        apps.removeAll()
    }
}

extension AppStateManager {
    func transition(appID: String, action: AppDownloadAction) {
        guard let index = apps.firstIndex(where: { $0.id == appID }) else { return }
        var app = apps[index]

        switch action {
        case .tapDownloadButton:
            switch app.state {
            case .get, .retry:
                app.state = .downloading
                DownloadTimerManager.shared.startTimer(for: appID)

            case .downloading:
                app.state = .paused
                DownloadTimerManager.shared.pauseTimer(for: appID)

            case .paused:
                app.state = .downloading
                DownloadTimerManager.shared.resumeTimer(for: appID)

            case .open:
                // 열기 상태에서는 버튼이 비활성화되거나 동작 없음
                break
            }

        case .systemInterrupted:
            if app.state == .downloading {
                app.state = .paused
                DownloadTimerManager.shared.pauseTimer(for: appID)
            }

        case .deletedFromList:
            if app.state == .open {
                app.state = .retry
                app.remainingTime = 30
            }
        }

        apps[index] = app
    }
}
