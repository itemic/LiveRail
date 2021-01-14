//
//  FareViews.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/14/21.
//

import SwiftUI

struct FareView: View {
    var fareSchedule: FareSchedule
    var body: some View {
        HStack(alignment: .center) {
            FareBlockView(ticket: .nonreserved, cost: fareSchedule.fare(for: .nonreserved))
            Spacer()
            Divider()
            Spacer()
            FareBlockView(ticket: .reserved, cost: fareSchedule.fare(for: .reserved))
            Spacer()
            Divider()
            Spacer()
            FareBlockView(ticket: .business, cost: fareSchedule.fare(for: .business))
        }
    }
}

struct FareBlockView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            FareBlockView(ticket: .business, cost: 1200)
        }
    }
}

struct FareBlockView: View {
    var ticket: FareClass
    var cost: Int
    
    var body: some View {
        VStack(spacing: -2) {
            Text("\(ticket.text())")
                .font(Font.system(.headline).smallCaps())
                .foregroundColor(ticket.color())
            
            Text("\(String(cost))").font(.system(.title, design: .rounded))
                
            
            Text("TWD").font(.caption2).foregroundColor(.secondary)
        }
    }
}
