//
//  AppListView.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI

struct AppListView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var searchText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 타이틀
            Text("앱")
                .font(.largeTitle)
                .bold()
                .padding(.top, 16)
                .padding(.horizontal)

            // 검색바 (UI만)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("게임, 앱, 스토리 등", text: $searchText)
                    .disabled(true)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 8)

            // 리스트 or EmptyView
            if appState.downloadedApps.isEmpty {
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Text("다운받은 앱이 없습니다.")
                            .foregroundColor(.gray)
                            .font(.body)
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                List {
                    ForEach(appState.downloadedApps) { app in
                        AppListRowView(app: app)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    appState.removeAppFromDownloadedList(appID: app.id)
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .padding(.top, 8)
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    AppListView()
}
