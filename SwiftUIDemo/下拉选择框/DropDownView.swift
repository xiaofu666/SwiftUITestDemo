//
//  DropDownView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/2.
//

import SwiftUI

struct DropDownView: View {
    @State private var selection: String = "Easy"
    var body: some View {
        VStack {
            DropDown(
                content: ["Easy", "Normal", "Hard", "Expert"],
                selection: $selection,
                activeTint: .primary.opacity(0.2),
                inActiveTint: .white.opacity(0.05),
                dynamic: false)
            .frame(width: 130)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView()
    }
}

struct DropDown: View {
    var content: [String]
    @Binding var selection: String
    var activeTint: Color
    var inActiveTint: Color
    var dynamic: Bool = true
    @State private var expandView: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(alignment: .leading, spacing: 0) {
                if !dynamic {
                    RowView(title: selection, size: size)
                }
                ForEach(content.filter({
                    dynamic ? true : $0 != selection
                }), id:\.self) { title in
                    RowView(title: title, size: size)
                }
            }
            .background {
                Rectangle()
                    .fill(inActiveTint)
            }
            .offset(y: dynamic ? CGFloat(content.firstIndex(of: selection) ?? 0) * -55 : 0)
        }
        .frame(height: 55)
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.up.chevron.down")
                .padding(.trailing, 10)
        }
        .mask(alignment: .top) {
            Rectangle()
                .frame(height: expandView ? CGFloat(content.count) * 55 : 55)
                .offset(y: dynamic && expandView ? CGFloat(content.firstIndex(of: selection) ?? 0) * -55 : 0)
        }
    }
    
    @ViewBuilder
    func RowView(title: String, size: CGSize) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background {
                if selection == title {
                    Rectangle()
                        .fill(activeTint)
                        .transition(.identity)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    if expandView {
                        expandView = false
                        if dynamic {
                            selection = title
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                selection = title
                            }
                        }
                    } else {
                        if selection == title {
                            expandView = true
                        }
                    }
                }
            }
    }
}
