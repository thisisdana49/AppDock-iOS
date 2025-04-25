//
//  DownloadTimerController.swift
//  AppDock
//
//  Created by 조다은 on 4/25/25.
//

import Foundation
import Combine

final class DownloadTimerController {
    // MARK: - Public Properties

    @Published private(set) var remainingTime: TimeInterval
    @Published private(set) var isRunning: Bool = false

    /// 타이머 종료 시 호출될 콜백
    var onComplete: (() -> Void)?

    /// 타이머 상태 갱신 시 호출될 콜백 (옵션)
    var onTick: ((TimeInterval) -> Void)?

    // MARK: - Private

    private var timer: Timer?
    private var appID: String
    private var interval: TimeInterval = 1.0

    // MARK: - Init

    init(appID: String, initialTime: TimeInterval = 30) {
        self.appID = appID
        self.remainingTime = initialTime
    }

    // MARK: - Public Control

    func start() {
        guard !isRunning else { return }
        isRunning = true
        runTimer()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func resume() {
        guard !isRunning, remainingTime > 0 else { return }
        isRunning = true
        runTimer()
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingTime = 30
    }

    // MARK: - Timer Logic

    private func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.remainingTime -= self.interval
            self.onTick?(self.remainingTime)

            if self.remainingTime <= 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.isRunning = false
                self.remainingTime = 0
                self.onComplete?()
            }
        }

        RunLoop.current.add(timer!, forMode: .common)
    }
}
