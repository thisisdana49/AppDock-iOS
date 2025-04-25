//
//  AppStateStore.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation

final class AppStateStore {
    static let shared = AppStateStore()

    private let key = "saved_apps"

    private init() {}

    // 저장
    func save(apps: [AppItem]) {
        do {
            let data = try JSONEncoder().encode(apps)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("🔥 앱 상태 저장 실패: \(error)")
        }
    }

    // 복원
    func load() -> [AppItem] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }

        do {
            var apps = try JSONDecoder().decode([AppItem].self, from: data)
            apps = apps.map { app in
                var mutableApp = app
                switch app.state {
                case .downloading:
                    mutableApp.state = .paused // 다운로드 중이던 앱은 재개 대기 상태로
                default:
                    break
                }
                return mutableApp
            }
            return apps
        } catch {
            print("🔥 앱 상태 복원 실패: \(error)")
            return []
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
