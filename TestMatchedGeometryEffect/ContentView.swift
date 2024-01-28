//
//  ContentView.swift
//  TestMatchedGeometryEffect
//
//  Created by Macbook Pro on 25.01.2024.
//

import SwiftUI

struct ArticleModel: Hashable {
    let id: Int
    let imageName: String
    let titleText: String
    let subtitleText: String
    let content: [String?]
    
    init(id: Int, imageName: String, titleText: String, subtitleText: String, content: [String?] = []) {
        self.id = id
        self.imageName = imageName
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.content = content
    }
}

struct ContentView: View {
    @Namespace private var scrollNameSpace
    @State var isOpen: Bool = false
    @State var selectedArticle: ArticleModel? = nil
    let colors: [Color] = [.red, .green, .blue, .yellow, .teal, .orange, .pink, .purple]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screen = geometry.size
                
                ZStack {
                    ScrollView {
                        VStack(spacing: Style.spacing.medium) {
                            ForEach(ContentView.articles, id: \.self) { article in
                                makeOwlCard(article: article, geometry: geometry)
                            }
                        }
                        .padding()
                    }
                    if isOpen {
                        if let selectedArticle = selectedArticle {
                            makeOwlViewer(selected: selectedArticle, geometry: geometry)
                        }
                    }
                }
                .frame(width: screen.width, height: screen.height)
                .background(
                    ZStack {
                        Color.white
                        Color.black.opacity(0.8)
                    }
                    .ignoresSafeArea()
                )
            }
        }
    }
    
    @ViewBuilder
    func makeOwlViewer(selected: ArticleModel, geometry: GeometryProxy) -> some View {
        let screen = geometry.size
        
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.smooth) {
                            self.isOpen = false
                            self.selectedArticle = nil
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
    
    
    @ViewBuilder
    func makeOwlCard(article: ArticleModel, geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text(article.titleText)
                        .matchedGeometryEffect(id: "\(article.id).title", in: scrollNameSpace)
                        .frame(alignment: .leading)
                        .font(.largeTitle)
                        .padding(0)
                    Text(article.subtitleText)
                        .matchedGeometryEffect(id: "\(article.id).subtitle", in: scrollNameSpace)
                        .font(.caption)
                }
                EmptyView()
                    .matchedGeometryEffect(id: "\(article.id).content", in: scrollNameSpace)
                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width - 32)
            .background(.black)
            .foregroundStyle(Color.white)
        }
        .padding([.top, .horizontal])
        .matchedGeometryEffect(id: article.id, in: scrollNameSpace)
        .frame(width: geometry.size.width - 32, height: geometry.size.width - 32)
        .background(
            Image("Owl/\(article.imageName)")
                .resizable()
                .scaledToFill()
                .overlay(content: {
                    Color.black.opacity(0.3)
                        .matchedGeometryEffect(id: "\(article.id).overlay", in: scrollNameSpace)
                        .transition(.asymmetric(insertion: .opacity.animation(.easeIn.delay(0)), removal: .opacity))
                })
                .matchedGeometryEffect(id: "\(article.id).bgImage", in: scrollNameSpace)
        )
        .onTapGesture {
            withAnimation(.smooth) {
                self.isOpen.toggle()
                self.selectedArticle = article
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Style.cornerRadius.medium))
        .zIndex(selectedArticle == article ? 1.0 : 0.0)
    }
}

extension ContentView {
    static let articles: [ArticleModel] = [
        ArticleModel(id: 1, imageName: "owl1", titleText: "Sleepy looking owl", subtitleText: "This owl looks very sleepy"),
        ArticleModel(id: 2, imageName: "owl2", titleText: "Weird looking owl", subtitleText: "This owl looks kinda weird", content: ["Hello this is line 1"]),
        ArticleModel(id: 3, imageName: "owl3", titleText: "Another sleepy owl", subtitleText: "This owl is very sleepy", content: ["What's going on"]),
        ArticleModel(id: 4, imageName: "owl4", titleText: "Comfy owl in a house", subtitleText: "This owl looks very comfy", content: ["fsadf", "asdfsas"]),
        ArticleModel(id: 5, imageName: "owl5", titleText: "Fluffy owl", subtitleText: "This fluffy owl looks fluffy"),
        ArticleModel(id: 6, imageName: "owl6", titleText: "Owl", subtitleText: "Subtitle text is unnecessary here, it's an owl")
    ]
}

fileprivate struct Style {
    enum spacing {
        static let medium: CGFloat = 20
    }
    
    enum cornerRadius {
        static let medium: CGFloat = 20
    }
}

#Preview {
    ContentView()
}
