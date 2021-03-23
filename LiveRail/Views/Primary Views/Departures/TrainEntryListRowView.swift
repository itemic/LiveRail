//
//  LiveBoardListView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct TrainEntryListRowView: View {
    @AppStorage("showStopDots") var showStopDots = true
    
    @StateObject var data = HSRStore.shared
    
    var train: RailDailyTimetable
    var station: Station
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    
                    Text(LocalizedStringKey(train.DailyTrainInfo.direction.abbreviated))
                        .font(Font.system(.subheadline).bold())
                        .foregroundColor(train.DailyTrainInfo.direction.color)
                        .padding(4)
                        .background(train.DailyTrainInfo.direction.color.opacity(0.15))
                        .cornerRadius(5)
                    
                    
                    
                    Text("\(train.DailyTrainInfo.TrainNo)").font(Font.system(.headline).monospacedDigit().weight(.semibold))
                    
                    
                    
                    Spacer()
                    
                    if (!data.getTrainWillDepartAfterNow(for: train, at: station)) {
                        Text("DEPARTED")
                            .font(Font.system(.caption))
                            .foregroundColor(.white)
                            .padding(2)
                            .padding(.horizontal, 4)
                            .background(Color.red)
                            .cornerRadius(10)
                    } else if (data.getTrainIsDepartingSoon(for: train, at: station)) {
                        Text("LEAVING SOON")
                            .font(Font.system(.caption))
                            .foregroundColor(.black)
                            .padding(2)
                            .padding(.horizontal, 4)
                            .background(Color.hsrColor)
                            .cornerRadius(10)
                    }
                    
                    
                        
                        

                    
                }
                .padding(.horizontal, 5)
                
                HStack {
                    
                    VStack(alignment: .leading) {
                       
                        Text(LocalizedStringKey(train.DailyTrainInfo.EndingStationName.En)).font(Font.system(.title).weight(.semibold))
                    }
                   
                    Spacer()
                    
                    Text("\(data.getDepartureTime(for: train, at: station))").font(Font.system(.title).monospacedDigit().weight(.semibold))
                    
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
