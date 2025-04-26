//
//  SearchResponse.swift
//  AppDock
//
//  Created by 조다은 on 4/26/25.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [SearchResultItem]
}

struct SearchResultItem: Decodable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String?
}
