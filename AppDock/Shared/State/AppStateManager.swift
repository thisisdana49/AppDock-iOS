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
