//
//  SearchView.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        VStack(spacing: 20) {
            List {
                ForEach(viewModel.apps) { app in
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

            Button("더미 앱 삽입") {
                viewModel.injectDummyApps()
            }
        }
        .padding()
    }
}

#Preview {
    SearchView()
}
