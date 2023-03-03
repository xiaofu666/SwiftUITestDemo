//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/19.
//

import SwiftUI

struct ContentView: View {
    @State var value = 0
    var body: some View {
        VStack(spacing: 25) {
            RollingText(value: $value)
            
            Button("Change Value") {
                value = .random(in: 0...110)
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
