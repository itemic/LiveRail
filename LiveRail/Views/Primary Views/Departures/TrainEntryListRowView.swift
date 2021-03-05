//
//  LiveBoardListView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct TrainEntryListRowView: View {
    @AppStorage("showStopDots") var showStopDots = true
    
    @StateObject var data2 = HSRStore.shared
    
    var train: RailDailyTimetable
    var station: Station
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    
                    Text(LocalizedStringKey(train.DailyTrainInfo.direction.abbreviated))
                        .font(Font.system(.subheadline, design: .rounded).bold())
                        .foregroundColor(train.DailyTrainInfo.direction.color)
                        .padding(4)
                        .background(train.DailyTrainInfo.direction.color.opacity(0.15))
                        .cornerRadius(5)
                    
                    
                    
                    Text("\(train.DailyTrainInfo.TrainNo)").font(Font.system(.headline, design: .rounded).monospacedDigit().weight(.semibold))
                    
                    
                    
                    Spacer()
                    
                    if (!data2.getTrainWillDepartAfterNow(for: train, at: station)) {
                        Text("DEPARTED")
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(.red)
                            .padding(4)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(5)
                    } else if (data2.getTrainIsAtStation(for: train, at: station)) {
                        Text("LEAVING SOON")
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(.orange)
                            .padding(4)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(5)
                    }
                    
                    
                        
                        

                    
                }
                .padding(.horizontal, 5)
                
                HStack {
                    
                    VStack(alignment: .leading) {
                       
                        Text(LocalizedStringKey(train.DailyTrainInfo.EndingStationName.En)).font(Font.system(.title, design: .rounded).weight(.semibold))
                    }
                   
                    Spacer()
                    
                    Text("\(data2.getDepartureTime(for: train, at: station))").font(Font.system(.title, design: .rounded).monospacedDigit().weight(.semibold))
                    
                }
                .padding(.horizontal, 5)
    
                
            }
            .padding(.bottom, 10)
            .padding(.top, 5)
            .background(Color(UIColor.secondarySystemGroupedBackground))
        }
        .padding(.leading, 10)
        .background(train.DailyTrainInfo.direction.color)
        .cornerRadius(5)
            

            if(showStopDots) {
            VStack {
                StopPatternView(daily: train)
                    .padding([.bottom, .trailing], 5)
//                
            }
            }
        
    }//a
        
    
  
}




}
