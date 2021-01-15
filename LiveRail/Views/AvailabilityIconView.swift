//
//  AvailabilityIconView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//

import SwiftUI

struct AvailabilityIconView: View {
    var text: String
    var status: SeatAvailability
    var body: some View {
        VStack(alignment: .center) {

                
            Text(status.icon())
                .fontWeight(.heavy)
                .foregroundColor(status.color())
                .font(.title)
        }
        .frame(width: 50)
    }
}

struct AvailabilityIconView_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            AvailabilityIconView(text: "Standard", status: .limited)
         
        }.listStyle(InsetGroupedListStyle())
        
    }
}
