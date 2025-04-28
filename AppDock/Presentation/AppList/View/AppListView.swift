//
//  AppListView.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI
import Combine

struct AppListView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var searchText = ""
    
    private var displayApps: [AppItem] {
        if searchText.isEmpty {
            return appState.downloadedApps
        } else {
            return appState.downloadedApps.filter { app in
                app.name.localizedCaseInsensitiveContains(searchText) ||
                app.sellerName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("앱 검색", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if displayApps.isEmpty {
                    EmptyStateView(
                        message: "다운로드한 앱이 없습니다.\n앱스토어에서 앱을 검색하고 다운로드해보세요.",
                        icon: "square.and.arrow.down"
                    )
                } else {
                    List {
                        ForEach(displayApps) { app in
                            AppListRowView(app: app)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        appState.removeAppFromDownloadedList(appID: app.id)
                                    } label: {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("다운로드한 앱")
        }
    }
}

#Preview {
    AppListView()
        .environmentObject(AppStateManager.shared)
}
