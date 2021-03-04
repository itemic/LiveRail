//
//  EntryView.swift
//  HSRWidgetExtension
//
//  Created by Terran Kroft on 3/2/21.
//

import SwiftUI

struct EntryView: View {
    let model: WidgetContent
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "tram.fill")
            Text("Tainan").font(Font.system(.headline).bold())
            }
            
            Spacer()
            
            HStack {
                Capsule()
                    .fill(Color.northColor)
                    .frame(width: 5)
                    
                VStack(alignment: .leading) {
                    Text("Nangang").font(Font.system(.callout).weight(.semibold))
                    Text("0883").font(Font.system(.caption).monospacedDigit().weight(.regular))
                }
                Spacer()
                
                Text("18:03").font(Font.system(.title3).monospacedDigit())
            }
            Spacer()
            HStack {
                Capsule()
                    .fill(Color.southColor)
                    .frame(width: 5)
                    
                VStack(alignment: .leading) {
                    Text("Zuoying").font(Font.system(.callout).weight(.semibold))
                    Text("0836").font(Font.system(.caption).monospacedDigit().weight(.regular))
                }
                Spacer()
                
                Text("18:12").font(Font.system(.title3).monospacedDigit())
            }
            Spacer()
            Text("Last updated 81 minutes ago").font(.caption).foregroundColor(.secondary)
        }
        .padding()
        
    }
}
