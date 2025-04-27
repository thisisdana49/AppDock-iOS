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
    let artworkUrl512: String?
    let screenshotUrls: [String]?
    let description: String?
    let minimumOsVersion: String?
    let sellerName: String?
    let primaryGenreName: String?
    let genres: [String]?
    let version: String?
    let releaseNotes: String?
    let trackViewUrl: String?
    let price: Double?
    let formattedPrice: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
}
