//
//  ContentView.swift
//  Crawl
//
//  Created by Ian Wanyoike.
//  Copyright © 2020 Pocket Pot. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = CrawlViewModel(crawlable: JengaDocs())

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("Worm36")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 36.0,
                    height: 36.0
                ).padding(.bottom, 24)
                HStack {
                    Text("100th Character:")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(self.viewModel.hundredthCharacter)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                Spacer().frame(height: 24)
                HStack {
                    Text("Word Count:")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(self.viewModel.wordCount)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                Spacer().frame(height: 24)
                Text("Every 10th Character")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer().frame(height: 24)
                ScrollView(Axis.Set.vertical, showsIndicators: true) {
                    VStack {
                        Text(self.viewModel.everyTenthCharacter)
                    }.frame(width: geometry.size.width - 48)
                }
                Spacer().frame(height: 24)
                Button(
                    action: self.viewModel.crawl
                ) {
                    Text(self.viewModel.actionLabel).fontWeight(.bold).frame(
                        width: geometry.size.width - 48,
                        height: 48
                    )
                }.alert(item: self.$viewModel.alertMessage, content: { mesaage in
                    Alert(
                        title: Text(mesaage.title),
                        message: Text(mesaage.message),
                        primaryButton: .default(Text("Try again"), action: self.viewModel.crawl),
                        secondaryButton: .cancel(Text("Dismiss"))
                    )
                })
                .disabled(self.viewModel.crawling)
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 24
                    ).stroke(
                        Color.primary,
                        lineWidth: 2
                    )
                )
            }.padding(24)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
