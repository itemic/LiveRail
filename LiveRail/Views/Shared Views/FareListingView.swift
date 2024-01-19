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
        .padding(.horizontal)
        .padding(.vertical, 5)
//        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray4), lineWidth: 1.5))
    }
}

struct FareBlockView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
        HStack(alignment: .center) {
            
            FareBlockView(ticket: .nonreserved, cost: 880)
            
            Spacer()
            FareBlockView(ticket: .reserved, cost: 1100)
          
            Spacer()
            FareBlockView(ticket: .business, cost: 2450)
            
            
        }
        .padding(.horizontal, 10)
        .background(Color(UIColor.secondarySystemGroupedBackground))

        
    }
    }
}

struct FareBlockView: View {
    var ticket: FareClass
    var cost: Int
    
    var body: some View {
        HStack(spacing: 5) {
            
            VStack(alignment: .leading, spacing: -2) {
                Text(ticket.text())
                    .font(Font.system(.callout).smallCaps())
                        .foregroundColor(ticket.color())
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(String(cost))").font(Font.system(.title2).monospacedDigit())
                    Text("TWD").font(.caption2).foregroundColor(.secondary)
                }
                
                
            }
        }
        
        .frame(maxWidth: .infinity)
    }
}
