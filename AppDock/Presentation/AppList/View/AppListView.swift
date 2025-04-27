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
    @State private var searchText: String = ""
    @State private var filteredApps: [AppItem] = []
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 타이틀
            Text("앱")
                .font(.largeTitle)
                .bold()
                .padding(.top, 16)
                .padding(.horizontal)

            // 검색바 (실시간 필터링)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("게임, 앱, 스토리 등", text: $searchText)
                    .focused($isSearchFocused)
                    .onChange(of: searchText) { _ in
                        filterApps()
                    }
                    .submitLabel(.search)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top, 8)

            // 리스트 or EmptyView
            let displayApps = searchText.isEmpty ? appState.downloadedApps : filteredApps
            if displayApps.isEmpty {
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
                    ForEach(displayApps) { app in
                        AppListRowView(app: app)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    appState.removeAppFromDownloadedList(appID: app.id)
                                    filterApps()
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
        .onAppear {
            filterApps()
        }
        .onReceive(appState.$apps) { _ in
            filterApps()
        }
    }

    private func filterApps() {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if keyword.isEmpty {
            filteredApps = appState.downloadedApps
        } else {
            filteredApps = appState.downloadedApps.filter {
                $0.name.localizedCaseInsensitiveContains(keyword) ||
                $0.developer.localizedCaseInsensitiveContains(keyword)
            }
        }
    }
}

#Preview {
    AppListView()
}
