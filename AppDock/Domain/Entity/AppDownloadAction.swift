//
//  AppDownloadAction.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation

enum AppDownloadAction {
    case tapDownloadButton     // 사용자가 버튼을 눌렀을 때
    case systemInterrupted     // 네트워크 끊김 or 앱 종료
    case deletedFromList       // 열기 상태에서 삭제
}
