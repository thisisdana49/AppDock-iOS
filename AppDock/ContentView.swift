//
//  ContentView.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var timerWrapper = TimerWrapper()

    var body: some View {
        VStack(spacing: 20) {
            Text("⏱ 남은 시간: \(Int(timerWrapper.remainingTime))초")
                .font(.largeTitle)
                .bold()

            HStack(spacing: 20) {
                Button("시작") {
                    timerWrapper.start()
                }
                Button("일시정지") {
                    timerWrapper.pause()
                }
                Button("재개") {
                    timerWrapper.resume()
                }
            }
            .buttonStyle(.borderedProminent)

            if timerWrapper.isCompleted {
                Text("✅ 다운로드 완료!")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .padding()
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
