//
//  SearchView.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchTerm: String = ""
    @State private var selectedAppId: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("게임, 앱, 스토리 등", text: $searchTerm)
                        .foregroundColor(.primary)
                        .disableAutocorrection(true)
                        .foregroundColor(.secondary)
                        .onSubmit {
                            viewModel.searchApps(term: searchTerm)
                        }
                    Button(action: {
                        // 음성 인식 기능 연결 (추후 구현)
                    }) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }

                if let errorMessage = viewModel.errorMessage {
                    Text("오류 발생: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }

                List {
                    ForEach(viewModel.searchResults) { app in
                        ZStack {
                            NavigationLink(
                                destination: AppDetailView(appId: app.id),
                                tag: app.id,
                                selection: $selectedAppId
                            ) {
                                EmptyView()
                            }
                            .opacity(0)
                            AppSearchResultRowView(app: app) {
                                viewModel.didTapDownloadButton(appID: app.id)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .padding(.top)
            .navigationTitle("검색")
        }
    }
}

//#Preview {
//    SearchView()
//}
