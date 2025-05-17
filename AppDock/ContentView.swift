//
//  ContentView.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        TabView {
            TemporaryTabView(title: "투데이")
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("투데이")
                }
            TemporaryTabView(title: "게임")
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("게임")
                }
            AppListView()
                .tabItem {
                    Image(systemName: "square.stack.3d.up")
                    Text("앱")
                }
            TemporaryTabView(title: "Arcade")
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Arcade")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                }
        }
    }
}

final class TimerWrapper: ObservableObject {
    @Published var remainingTime: TimeInterval = 30
    @Published var isCompleted: Bool = false

    private var controller: DownloadTimerController

    init() {
        self.controller = DownloadTimerController(appID: "test", initialTime: 30)

        // 콜백 등록
        controller.onTick = { [weak self] time in
            DispatchQueue.main.async {
                self?.remainingTime = time
            }
        }

        controller.onComplete = { [weak self] in
            DispatchQueue.main.async {
                self?.isCompleted = true
            }
        }
    }

    func start() {
        isCompleted = false
        controller.start()
    }

    func pause() {
        controller.pause()
    }

    func resume() {
        controller.resume()
    }
}

#Preview {
    ContentView()
}
