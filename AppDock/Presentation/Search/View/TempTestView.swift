//
//  TempTestView.swift
//  AppDock
//
//  Created by 조다은 on 4/26/25.
//

import SwiftUI

struct TempTestView: View {
    
    @StateObject private var viewModel = TempTestViewModel()
    @State private var searchTerm: String = ""
    
    var body: some View {
        VStack {
            TextField("검색어 입력", text: $searchTerm)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button("검색하기") {
                viewModel.testSearch(term: searchTerm)
            }
            .padding()
            
            List(viewModel.searchResults, id: \.trackId) { item in
                VStack(alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.artistName)
                        .font(.subheadline)
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text("오류 발생: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    TempTestView()
}
