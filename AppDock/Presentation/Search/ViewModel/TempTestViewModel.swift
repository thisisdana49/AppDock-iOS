//
//  TempTestViewModel.swift
//  AppDock
//
//  Created by 조다은 on 4/26/25.
//

import Foundation

@MainActor
final class TempTestViewModel: ObservableObject {
    
    @Published var searchResults: [SearchResultItem] = []
    @Published var errorMessage: String?
    
    func testSearch(term: String) {
        Task {
            do {
                let response = try await APIClient.shared.searchApps(term: term)
                self.searchResults = response.results
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
