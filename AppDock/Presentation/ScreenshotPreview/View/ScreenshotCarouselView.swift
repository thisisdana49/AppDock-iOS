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

    init(screenshots: [ScreenshotItem], initialIndex: Int, isPresented: Binding<Bool>) {
        self.screenshots = screenshots
        self._selectedIndex = State(initialValue: initialIndex)
        self._isPresented = isPresented
    }

    var body: some View {
        GeometryReader { geometry in
            let imageWidthRatio: CGFloat = 0.8
            let spacing: CGFloat = 12
            let imageWidth = geometry.size.width * imageWidthRatio
            let sidePadding = (geometry.size.width - imageWidth) / 2
            ZStack(alignment: .top) {
                Color.white.ignoresSafeArea()
                VStack(spacing: 0) {
                    // 상단 버튼
                    HStack {
                        Button("완료") { isPresented = false }
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                        Button("열기") {
                            // 열기 액션: 상세화면의 버튼 로직을 외부에서 주입하거나, 추후 구현
                        }
                        .foregroundColor(.black)
                        .padding()
                    }
                    .padding(.top, 48)
                    .padding(.horizontal)

                    Spacer(minLength: 24)

                    // 캐러셀
                    ScrollViewReader { scrollProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: spacing) {
                                ForEach(Array(screenshots.enumerated()), id: \ .element.id) { idx, item in
                                    AsyncImage(url: URL(string: item.url)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: imageWidth)
                                            .cornerRadius(16)
                                            .shadow(radius: selectedIndex == idx ? 4 : 0)
                                            .scaleEffect(selectedIndex == idx ? 1.0 : 0.96)
                                            .opacity(selectedIndex == idx ? 1.0 : 0.7)
                                            .animation(.easeInOut, value: selectedIndex)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: imageWidth, height: imageWidth * 2)
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
                        .frame(height: geometry.size.height * 0.8)
                    }
                    Spacer()
                }
            }
        }
    }
} 
