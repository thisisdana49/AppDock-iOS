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
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            TabView(selection: $selectedIndex) {
                ForEach(Array(screenshots.enumerated()), id: \ .element.id) { idx, item in
                    AsyncImage(url: URL(string: item.url)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } placeholder: {
                        ProgressView()
                    }
                    .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            Button(action: { isPresented = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
} 
