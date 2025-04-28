//
//  ScreenshotCarouselView.swift
//  AppDock
//
//  Created by 조다은 on 4/27/25.
//

import SwiftUI

struct ScreenshotCarouselView: View {
    let screenshots: [ScreenshotItem]
    @Binding var isPresented: Bool
    @State private var selectedIndex: Int
    @GestureState private var dragOffset: CGFloat = 0
    let app: AppItem?
    let onDownload: (() -> Void)?

    init(screenshots: [ScreenshotItem], initialIndex: Int, isPresented: Binding<Bool>, app: AppItem? = nil, onDownload: (() -> Void)? = nil) {
        self.screenshots = screenshots
        self._selectedIndex = State(initialValue: initialIndex)
        self._isPresented = isPresented
        self.app = app
        self.onDownload = onDownload
    }

    var body: some View {
        GeometryReader { geometry in
            let imageWidthRatio: CGFloat = 0.8
            let spacing: CGFloat = 12
            let imageWidth = geometry.size.width * imageWidthRatio
            let sidePadding = (geometry.size.width - imageWidth) / 2
            let imageHeight = geometry.size.height * 0.9
            ZStack(alignment: .top) {
                Color.white.ignoresSafeArea()
                VStack(spacing: 0) {
                    // 상단 버튼
                    HStack {
                        Button("완료") { isPresented = false }
                            .font(.headline.bold())
                            .foregroundColor(.blue)
                            .padding()
                        Spacer()
                        if let app = app, let onDownload = onDownload {
                            switch app.state {
                            case .get:
                                Button(action: onDownload) {
                                    Text("받기")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color(.systemGray6))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PlainButtonStyle())
                            case .downloading:
                                Button(action: onDownload) {
                                    DownloadProgressCircleView(
                                        progress: 1.0 - (app.remainingTime / 30.0),
                                        isPaused: false
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            case .paused:
                                Button(action: onDownload) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "icloud.and.arrow.down")
                                        Text("재개")
                                    }
                                    .font(.subheadline.bold())
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemGray6))
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(PlainButtonStyle())
                            case .open:
                                Button(action: onDownload) {
                                    Text("열기")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color(.systemGray6))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PlainButtonStyle())
                            case .retry:
                                Button(action: onDownload) {
                                    Image(systemName: "icloud.and.arrow.down")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color(.systemGray6))
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)

                    // 캐러셀
                    ScrollViewReader { scrollProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: spacing) {
                                ForEach(Array(screenshots.enumerated()), id: \ .element.id) { idx, item in
                                    AsyncImage(url: URL(string: item.url)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth, height: imageHeight)
                                            .cornerRadius(16)
                                            .shadow(radius: selectedIndex == idx ? 4 : 0)
                                            .scaleEffect(selectedIndex == idx ? 1.0 : 0.96)
                                            .opacity(selectedIndex == idx ? 1.0 : 0.7)
                                            .animation(.easeInOut, value: selectedIndex)
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: imageWidth, height: imageHeight)
                                    }
                                    .id(idx)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedIndex = idx
                                            scrollProxy.scrollTo(idx, anchor: .center)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, sidePadding)
                            .offset(x: dragOffset)
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset) { value, state, _ in
                                        state = value.translation.width
                                    }
                                    .onEnded { value in
                                        let offset = -value.translation.width / (imageWidth + spacing)
                                        let newIndex = (CGFloat(selectedIndex) + offset).rounded()
                                        let clamped = min(max(Int(newIndex), 0), screenshots.count - 1)
                                        withAnimation {
                                            selectedIndex = clamped
                                            scrollProxy.scrollTo(clamped, anchor: .center)
                                        }
                                    }
                            )
                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                scrollProxy.scrollTo(selectedIndex, anchor: .center)
                            }
                        }
                        .onChange(of: selectedIndex) { idx in
                            withAnimation {
                                scrollProxy.scrollTo(idx, anchor: .center)
                            }
                        }
                        .frame(height: imageHeight)
                    }
                    Spacer()
                }
            }
        }
    }
} 
