//
//  AppListView.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI

struct AppListView: View {
    @EnvironmentObject var appState: AppStateManager

    var body: some View {
        NavigationView {
            List {
                ForEach(appState.downloadedApps) { app in
                    HStack {
                        Text(app.name)
                        Spacer()
                        Text("열기")
                            .foregroundColor(.blue)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            appState.removeAppFromDownloadedList(appID: app.id)
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("내 앱 목록")
        }
    }
}

#Preview {
    AppListView()
}
