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

    @Published var apps: [AppItem] = [] {
        didSet {
            AppStateStore.shared.save(apps: apps)
        }
    }

    private init() {
        self.apps = AppStateStore.shared.load()
    }

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
    private var backgroundTimestampKey: String { "background_timestamp" }

    func markBackgroundTimestamp() {
        let now = Date()
        UserDefaults.standard.set(now, forKey: backgroundTimestampKey)
        print("⏱ Background 진입 시간 저장: \(now)")
    }

    func syncTimersOnResume() {
        guard let savedTime = UserDefaults.standard.object(forKey: backgroundTimestampKey) as? Date else { 
            print("⚠️ 저장된 Background 시간 없음")
            return 
        }

        let elapsed = max(0, Date().timeIntervalSince(savedTime))
        print("📦 경과 시간: \(elapsed)초")

        for app in apps {
            guard app.state == .downloading else { continue }
            print("🔄 앱 상태 동기화 - \(app.name)")
            print("  ㄴ 현재 남은 시간: \(app.remainingTime)초")

            let newRemaining = max(0, app.remainingTime - elapsed)
            print("  ㄴ 보정된 남은 시간: \(newRemaining)초")

            if newRemaining <= 0 {
                print("  ㄴ ✅ 다운로드 완료로 전환")
                update(app.copyWith(state: .open, remainingTime: 0))
                DownloadTimerManager.shared.cancelTimer(for: app.id)
            } else {
                print("  ㄴ ⏳ 남은 시간 보정 및 타이머 재시작")
                update(app.copyWith(state: .downloading, remainingTime: newRemaining))
                DownloadTimerManager.shared.startTimer(for: app.id)
            }
        }
    }
    
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
    
    var downloadedApps: [AppItem] {
        apps.filter { $0.state == .open }
    }

    func removeAppFromDownloadedList(appID: String) {
        guard let index = apps.firstIndex(where: { $0.id == appID }) else { return }

        var app = apps[index]
        app.state = .retry
        app.remainingTime = 30

        apps[index] = app
    }
}
