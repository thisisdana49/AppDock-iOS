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

    var state: AppDownloadState
    var remainingTime: TimeInterval
}

extension AppItem {
    func copyWith(state: AppDownloadState? = nil,
                  remainingTime: TimeInterval? = nil) -> AppItem {
        AppItem(
            id: self.id,
            name: self.name,
            developer: self.developer,
            iconURL: self.iconURL,
            state: state ?? self.state,
            remainingTime: remainingTime ?? self.remainingTime
        )
    }
}
