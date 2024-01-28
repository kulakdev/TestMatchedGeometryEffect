//
//  OwlView.swift
//  TestMatchedGeometryEffect
//
//  Created by Macbook Pro on 27.01.2024.
//

import SwiftUI

struct OwlView: View {
    @Environment(\.dismiss) var dismiss
    let geometry: GeometryProxy
    let scrollNameSpace: Namespace.ID
    let selected: ArticleModel
    
    var body: some View {
        let screen = geometry.size
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.smooth) {
                            dismiss()
                        }
                    }, label: {
                        Image(systemName: "xmark.app")
                            .resizable()
                            .frame(width: 28, height: 28)
                    })
                }
                .padding()
                .zIndex(10.0)
                VStack(alignment: .leading) {
                    Image("Owl/\(selected.imageName)")
                        .resizable()
                        .scaledToFill()
                        .matchedGeometryEffect(id: "\(selected.id).bgImage", in: scrollNameSpace)
                        .frame(width: screen.width + 2, height: 200)
                        .clipped()
                        .transition(.opacity)
                        .overlay(content: {
                            Color.clear
                                .matchedGeometryEffect(id: "\(selected.id).overlay", in: scrollNameSpace)
                                .transition(.asymmetric(insertion: .opacity.animation(.easeInOut), removal: .opacity))
                        })
                    Text(selected.titleText)
                        .font(.largeTitle)
                        .matchedGeometryEffect(id: "\(selected.id).title", in: scrollNameSpace)
                    Text(selected.subtitleText)
                        .font(.caption)
                        .matchedGeometryEffect(id: "\(selected.id).subtitle", in: scrollNameSpace)
                    if !selected.content.isEmpty {
                        VStack {
                            ForEach(selected.content, id: \.self) { string in
                                if string != nil, string != nil {
                                    Text(string!)
                                }
                            }
                        }
                        .transition(.asymmetric(insertion: .opacity.animation(.easeIn.delay(0.5)), removal: .opacity.animation(.none)))
                        .matchedGeometryEffect(id: "\(selected.id).content", in: scrollNameSpace)
                    }
                    
                    
                }
            }
            .foregroundStyle(Color.white)
            .padding()
        }
        .matchedGeometryEffect(id: selected.id, in: scrollNameSpace)
        .transition(
            .asymmetric(
                insertion: .opacity,
                removal: .opacity.animation(.easeInOut.delay(0.2)))
        )
        .background(.black)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }
}

#Preview {
    GeometryReader { geometry in
        @Namespace var preview
        OwlView(geometry: geometry, scrollNameSpace: preview, selected: ArticleModel(id: 0, imageName: "owl1", titleText: "Preview", subtitleText: "Preview content full of text"))
    }
}
