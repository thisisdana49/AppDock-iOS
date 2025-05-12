//
//  AppDockApp.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI

@main
struct AppDockApp: App {
    @StateObject private var appState = AppStateManager.shared
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .background:
                        appState.markBackgroundTimestamp()
                    case .active:
                        appState.syncTimersOnResume()
                    default:
                        break
                    }
                }
        }
    }
}
