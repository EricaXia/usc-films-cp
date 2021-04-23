//
//  Toast.swift
//
//
//  Created by Erica Xia on 4/21/21.
//
import SwiftUI
import Foundation


extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}

struct Toast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    Capsule()
                        .fill(Color.gray)

                    self.content() // the Movie Poster
                    
                } //ZStack (inner)
                
//                .frame(width: geometry.size.width / 1.25, height: geometry.size.height / 10)
                .frame(width: geometry.size.width, height: geometry.size.height * 2)

                .opacity(self.isPresented ? 1 : 0)
            } //ZStack (outer)
            .padding(.bottom, 300)
        } //GeometryReader
    } //body
} //Toast
