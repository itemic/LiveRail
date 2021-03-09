//
//  WhatsNew.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/9/21.
//

import SwiftUI

struct WhatsNewView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
            Text("New Features").font(.title)
        
            HStack {
                Spacer()
                Image(systemName: "memorychip").font(.largeTitle).foregroundColor(.hsrColor)
                VStack(alignment: .leading) {
                    Text("Faster.").bold()
                    Text("Updated internal architecture means Live Rail should be faster and crash less frequently. Let me know if it still crashes though.").font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Image(systemName: "clock.fill").font(.largeTitle).foregroundColor(.hsrColor)
                VStack(alignment: .leading) {
                    Text("Works in all time zones").bold()
                    Text("Now shows Taiwan time wherever you are, because that's what really matters.").font(.subheadline)
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                Image(systemName: "clock.fill").font(.largeTitle).foregroundColor(.hsrColor)
                VStack(alignment: .leading) {
                    Text("Third tentpole feature").bold()
                    Text("Look, I don't have proper text for this yet so hopefully this will be updated before I fix it. Oh, right, iPad and Mac support.").font(.subheadline)
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}


