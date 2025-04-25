//
//  AppDownloadState.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation

enum AppDownloadState: String, Equatable {
    case get          // 받기
    case downloading  // 다운로드중
    case paused       // 재개
    case open         // 열기
    case retry        // 다시받기
}
