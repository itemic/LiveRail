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
            
            
            HStack {
                Circle()
                    .fill(Color.northColor)
                    .frame(width: 10, height: 10)
                
                Text("0831").font(Font.system(.body).monospacedDigit())
                Text("Nangang").font(Font.system(.body))
                
                Spacer()
                Text("13:39").font(Font.system(.body).monospacedDigit().weight(.light))
            }
            HStack {
                Circle()
                    .fill(Color.northColor)
                    .frame(width: 10, height: 10)
                
                Text("0831").font(Font.system(.body).monospacedDigit())
                Text("Nangang").font(Font.system(.body))
                
                Spacer()
                Text("13:51").font(Font.system(.body).monospacedDigit().weight(.light))
            }
            HStack {
                Circle()
                    .fill(Color.southColor)
                    .frame(width: 10, height: 10)
                
                Text("0838").font(Font.system(.body).monospacedDigit())
                Text("Zuoying").font(Font.system(.body))
                
                Spacer()
                Text("14:02").font(Font.system(.body).monospacedDigit().weight(.light))
            }
            
            
            
        }
        .padding()
        
    }
}
