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
        VStack(alignment: .center) {
            Text("Tainan".uppercased())
                .font(Font.system(.subheadline).bold())
                .foregroundColor(.white)
                
            Spacer()
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Nangang")
                    Text("12:12")
                        .font(Font.system(.title).monospacedDigit())
                    
                }
                Spacer()
            }
            .background(Color.northColor)
            HStack {
                VStack(alignment: .leading) {
                    Text("Zuoying")
                    Text("12:03")
                        .font(Font.system(.title).monospacedDigit())
                    
                }
                Spacer()
            }
            .background(Color.southColor)
            
            
        }
//        .padding()
    }
}
