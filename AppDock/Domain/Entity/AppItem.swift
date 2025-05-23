//
//  AppItem.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation

struct AppItem: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let developer: String
    let iconURL: URL?
    let screenshotURLs: [URL]
    let description: String
    let minimumOSVersion: String
    let sellerName: String
    let primaryGenreName: String
    let genres: [String]
    let version: String
    let releaseNotes: String?
    let trackViewUrl: URL?
    let price: Double
    let formattedPrice: String?
    let averageUserRating: Double?
    let contentAdvisoryRating: String?
    
    var state: AppDownloadState
    var remainingTime: TimeInterval
    var downloadedAt: Date?
}

extension AppItem {
    func copyWith(state: AppDownloadState? = nil,
                  remainingTime: TimeInterval? = nil,
                  downloadedAt: Date? = nil) -> AppItem {
        AppItem(
            id: self.id,
            name: self.name,
            developer: self.developer,
            iconURL: self.iconURL,
            screenshotURLs: self.screenshotURLs,
            description: self.description,
            minimumOSVersion: self.minimumOSVersion,
            sellerName: self.sellerName,
            primaryGenreName: self.primaryGenreName,
            genres: self.genres,
            version: self.version,
            releaseNotes: self.releaseNotes,
            trackViewUrl: self.trackViewUrl,
            price: self.price,
            formattedPrice: self.formattedPrice,
            averageUserRating: self.averageUserRating,
            contentAdvisoryRating: self.contentAdvisoryRating,
            state: state ?? self.state,
            remainingTime: remainingTime ?? self.remainingTime,
            downloadedAt: downloadedAt ?? self.downloadedAt
        )
    }
}
