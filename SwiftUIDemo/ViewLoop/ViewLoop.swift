//
//  ViewLoop.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/23.
//

import SwiftUI

struct ViewLoop: View {
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var index = 0
    var body: some View {
        VStack {
            TabView(selection: $index) {
                ForEach (1..<6) { i in
                    Image("user\(i)")
                        .resizable()
                        .ignoresSafeArea()
                }
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .onReceive(timer) { _ in
                withAnimation {
                    index = index < 5 ? index + 1 : 0
                }
            }
        }.ignoresSafeArea()
    }
}

struct ViewLoop_Previews: PreviewProvider {
    static var previews: some View {
        ViewLoop()
    }
}
