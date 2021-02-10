//
//  LiveBoardListView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct TrainEntryListRowView: View {
    @StateObject var data = HSRDataStore.shared
    
    var train: StationTimetable
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    
                    Text(LocalizedStringKey(train.direction.abbreviated))
                        .font(Font.system(.subheadline, design: .rounded).bold())
                        .foregroundColor(train.direction.color)
                        .padding(4)
                        .background(train.direction.color.opacity(0.15))
                        .cornerRadius(5)
                    
                    
                    
                    Text("\(train.TrainNo)").font(Font.system(.headline, design: .rounded).monospacedDigit().weight(.semibold))
                    
                    
                    
                    
                    
                    if (!train.willDepartAfterNow) {
                        Text("DEPARTED")
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(.red)
                            .padding(4)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(5)
                    } else if (train.isAtStation) {
                        Text("LEAVING SOON")
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(.orange)
                            .padding(4)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(5)
                    }
                    Spacer()
                    StopPatternView(daily: data.getDailyFromStation(stt: train)!)

                    
                }
                .padding(.horizontal, 10)
                
                HStack {
                    
                    VStack(alignment: .leading) {
                       
                        Text(LocalizedStringKey(train.EndingStationName.En)).font(Font.system(.title, design: .rounded).weight(.semibold))
                    }
                   
                    Spacer()
                Text("\(train.DepartureTime)").font(Font.system(.title, design: .rounded).monospacedDigit().weight(.semibold))
//                    Spacer()
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
            .background(Color(UIColor.secondarySystemGroupedBackground))
        }
        .padding(.leading, 10)
        .background(train.direction.color)
        .cornerRadius(5)
        
        
    
  
}




}
