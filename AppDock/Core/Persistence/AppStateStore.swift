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
        guard let data = UserDefaults.standard.data(forKey: key) else { 
            print("📱 저장된 앱 상태 없음")
            return [] 
        }

        do {
            var apps = try JSONDecoder().decode([AppItem].self, from: data)
            print("📱 앱 상태 복원 시작 - \(apps.count)개의 앱")
            
            apps = apps.map { app in
                var mutableApp = app
                print("  ㄴ \(app.name) 상태 복원 중...")
                
                switch app.state {
                case .downloading:
                    mutableApp.state = .paused // 다운로드 중이던 앱은 재개 대기 상태로
                    print("    ㄴ 다운로드 중이던 앱을 재개 대기 상태로 전환")
                    
                    // 남은 시간 보정
                    if let savedTime = UserDefaults.standard.object(forKey: "background_timestamp") as? Date {
                        let elapsed = max(0, Date().timeIntervalSince(savedTime))
                        let originalTime = mutableApp.remainingTime
                        mutableApp.remainingTime = max(0, mutableApp.remainingTime - elapsed)
                        print("    ㄴ 남은 시간 보정: \(originalTime)초 → \(mutableApp.remainingTime)초 (경과: \(elapsed)초)")
                    } else {
                        print("    ㄴ ⚠️ Background 시간 정보 없음")
                    }
                default:
                    print("    ㄴ 상태 유지: \(app.state)")
                    break
                }
                return mutableApp
            }
            print("📱 앱 상태 복원 완료")
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
