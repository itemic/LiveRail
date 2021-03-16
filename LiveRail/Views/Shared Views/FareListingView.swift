//
//  FareViews.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/14/21.
//

import SwiftUI

struct FareListingView: View {
    var fareSchedule: FareSchedule
    var body: some View {
        HStack(alignment: .center) {
            
            FareBlockView(ticket: .nonreserved, cost: fareSchedule.fare(for: .nonreserved))
            
            Spacer()
            FareBlockView(ticket: .reserved, cost: fareSchedule.fare(for: .reserved))
          
            Spacer()
            FareBlockView(ticket: .business, cost: fareSchedule.fare(for: .business))
            
            
        }
    }
}

struct FareBlockView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
        HStack(alignment: .center) {
            
            
            FareBlockView(ticket: .nonreserved, cost: 80)
            Spacer()
            
            
            
            
            FareBlockView(ticket: .reserved, cost: 120)
            
            
            
            
            Spacer()
            FareBlockView(ticket: .business, cost: 1440)
            
//            Spacer()
        }}
    }
}

struct FareBlockView: View {
    var ticket: FareClass
    var cost: Int
    
    var body: some View {
        HStack(spacing: 5) {
            Rectangle()
                .fill(ticket.color())
                .frame(width: 5)
            VStack(alignment: .leading, spacing: -2) {
                
                
                
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(String(cost))").font(Font.system(.title2).monospacedDigit())
                Text("TWD").font(.caption2).foregroundColor(.secondary)
                    
                    
                }
                Text(ticket.text())
                        .font(Font.system(.footnote).smallCaps())
                        .foregroundColor(ticket.color())
            }
        }
    }
}
