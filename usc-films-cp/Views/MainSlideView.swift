//
//  MainSlideView.swift
//  usc-films
//
//  Created by Erica Xia on 4/15/21.
//

import SwiftUI
import Combine

struct MainSlideView<Content: View>: View {
    private var numSlides: Int
    private var content: Content
    
    @State private var currIndex: Int = 0
    @State private var offsetMultiplier: Float = 1.0
    
    init(numSlides: Int, @ViewBuilder content: () -> Content) {
        self.numSlides = numSlides
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack {
                self.content
            }
            .padding(.trailing)
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
            // go to next slide by changing the offset position
            .offset(x: CGFloat(self.currIndex) * -proxy.size.width * CGFloat(self.offsetMultiplier), y: 0)
            // change every 3 seconds
        .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
            if self.currIndex >= 4 {
                self.currIndex = (self.currIndex + 1) % 5
                self.offsetMultiplier = 1.0
            } else {
                self.currIndex = (self.currIndex + 1) % 5
                self.offsetMultiplier = self.offsetMultiplier + 0.005

            }

        }
        .animation(.spring())
        }
    }
}
