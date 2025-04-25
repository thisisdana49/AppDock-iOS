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
