//
//  AppDockApp.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI

@main
struct AppDockApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView()
                    .tabItem { Label("검색", systemImage: "magnifyingglass") }

                AppListView()
                    .tabItem { Label("내 앱", systemImage: "square.stack") }
            }
            .environmentObject(AppStateManager.shared)
        }
    }
}
