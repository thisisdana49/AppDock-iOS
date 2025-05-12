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
    @State private var isShowingErrorAlert: Bool = false

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
                        .onAppear {
                            isShowingErrorAlert = true
                        }
                }

                if viewModel.searchResults.isEmpty {
                    if searchTerm.isEmpty {
                        EmptyStateView(
                            message: "원하는 앱을 검색해보세요",
                            icon: "magnifyingglass"
                        )
                    } else {
                        EmptyStateView(
                            message: "검색 결과가 없습니다. 다른 키워드로 검색해보세요.",
                            icon: "exclamationmark.circle"
                        )
                    }
                } else {
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
            }
            .padding(.top)
            .navigationTitle("검색")
            .alert(isPresented: $isShowingErrorAlert) {
                Alert(
                    title: Text("오류"),
                    message: Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다."),
                    dismissButton: .default(Text("확인")) {
                        viewModel.errorMessage = nil
                    }
                )
            }
        }
    }
}

//#Preview {
//    SearchView()
//}
