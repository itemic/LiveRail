//
//  NewsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 5/20/21.
//

import SwiftUI

struct NewsView: View {
    @StateObject var store = NewsStore.shared
    let df = SharedDateFormatter.shared
    
    var body: some View {
        List {
            Section {
                Text("NEWS_DESCRIPTOR_HEADER")
            }
            Section {
            ForEach(store.newsPosts) { post in
                VStack {
                    HStack {
                        Text(post.NewsCategory)
                            .bold()
                            .font(.caption)
                            .padding(3)
                            .background(Color.hsrColor)
                            .cornerRadius(5)
                            .foregroundColor(.white)
                        Spacer()
                        Text(df.isoDate(from: post.StartTime)!, style: .date)
                            .fontWeight(.light)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    HStack {
                        Link(post.Title, destination: URL(string: post.NewsUrl) ?? URL(string: "https://www.thsrc.com.tw")!)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                
            }
            }
            
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("HSR News/Updates")
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
