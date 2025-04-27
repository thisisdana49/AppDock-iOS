//
//  APIClient.swift
//  AppDock
//
//  Created by 조다은 on 4/26/25.
//

import Foundation

final class APIClient {
    
    static let shared = APIClient()
    private init() { }
    
    func searchApps(term: String) async throws -> SearchResponse {
        guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "entity", value: "software"),
            URLQueryItem(name: "country", value: "kr")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
        return decoded
    }
}
