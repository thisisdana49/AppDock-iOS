//
//  DefaultAppDownloadUseCase.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation

final class DefaultAppDownloadUseCase: AppDownloadUseCase {
    private let appStateManager: AppStateManager

    init(appStateManager: AppStateManager = .shared) {
        self.appStateManager = appStateManager
    }

    func handleUserAction(appID: String) {
        appStateManager.transition(appID: appID, action: .tapDownloadButton)
    }
}
