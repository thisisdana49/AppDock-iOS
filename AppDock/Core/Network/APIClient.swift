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
    
    private var searchBaseURL: String {
        Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL_SEARCH") as? String ?? "https://itunes.apple.com/search"
    }
    private var lookupBaseURL: String {
        Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL_LOOKUP") as? String ?? "https://itunes.apple.com/lookup"
    }
    
    func searchApps(term: String) async throws -> SearchResponse {
        guard var urlComponents = URLComponents(string: searchBaseURL) else {
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
    
    func lookupApp(id: String, country: String = "kr") async throws -> SearchResponse {
        guard var urlComponents = URLComponents(string: lookupBaseURL) else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: id),
            URLQueryItem(name: "country", value: country)
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
