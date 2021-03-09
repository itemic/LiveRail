//
//  AvailabilityIconView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//

import SwiftUI

struct AvailabilityIconView: View {
    var text: LocalizedStringKey
    var status: SeatAvailability
    var body: some View {
//        VStack(alignment: .center) {
            Text(status.icon())
                .font(Font.system(size: 16, design: .monospaced))
                .foregroundColor(status.color())
//                .imageScale(.small)
//        }
                .frame(width: 20, height: 20)
    }
}

struct AvailabilityIconView_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            AvailabilityIconView(text: "Standard", status: .limited)
            
        }.listStyle(InsetGroupedListStyle())
        
    }
}
