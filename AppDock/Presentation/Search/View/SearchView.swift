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

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("앱 이름 검색", text: $searchTerm)
                    .textFieldStyle(.roundedBorder)
                
                Button("검색") {
                    viewModel.searchApps(term: searchTerm)
                }
                .buttonStyle(.borderedProminent)
            }
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
                    HStack {
                        Text(app.name)
                        Spacer()
                        Button(app.state.labelText) {
                            viewModel.didTapDownloadButton(appID: app.id)
                        }
                        .buttonStyle(.borderedProminent)

                        if app.state == .downloading || app.state == .paused {
                            Text("(\(Int(app.remainingTime))s)")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.top)
    }
}

//#Preview {
//    SearchView()
//}
