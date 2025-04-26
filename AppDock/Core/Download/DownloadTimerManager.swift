//
//  DownloadTimerManager.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation

final class DownloadTimerManager {
    // TODO: Singleton 또는 외부 주입 선택 가능
    static let shared = DownloadTimerManager()

    private var timers: [String: DownloadTimerController] = [:]
    private let appStateManager = AppStateManager.shared

    private init() {}

    // MARK: - Public API

    func startTimer(for appID: String) {
        guard let app = appStateManager.apps.first(where: { $0.id == appID }) else { return }

        if timers[appID] == nil {
            let controller = DownloadTimerController(appID: appID, initialTime: app.remainingTime)

            controller.onTick = { [weak self] remaining in
                self?.updateApp(appID: appID) { $0.remainingTime = remaining }
            }

            controller.onComplete = { [weak self] in
                self?.updateApp(appID: appID) { $0.state = .open; $0.remainingTime = 0 }
                self?.timers[appID] = nil
            }

            timers[appID] = controller
        }

        timers[appID]?.start()
    }

    func pauseTimer(for appID: String) {
        timers[appID]?.pause()
    }

    func resumeTimer(for appID: String) {
        timers[appID]?.resume()
    }

    func cancelTimer(for appID: String) {
        timers[appID]?.cancel()
        timers[appID] = nil
    }

    // MARK: - Helpers

    private func updateApp(appID: String, mutation: (inout AppItem) -> Void) {
        guard let index = appStateManager.apps.firstIndex(where: { $0.id == appID }) else { return }
        var app = appStateManager.apps[index]
        mutation(&app)
        appStateManager.update(app)
    }
}
