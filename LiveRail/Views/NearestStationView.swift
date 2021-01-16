//
//  NearestStationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//

import SwiftUI

struct NearestStationView: View {
    var station: Station?
    @ObservedObject var data: HSRDataStore
    
    var firstNth: StationTimetable? {
        if let station = station {
            return data.stationTimetableDict[station]?.first {
                $0.Direction == 1 &&
                    Date.compareNowTo(otherTime: $0.DepartureTime)
                    && !$0.isTerminus
                
            }
        }
        return nil
    }
    
    var firstSth: StationTimetable? {
        if let station = station {
            return data.stationTimetableDict[station]?.first {
                $0.Direction == 0 &&
                    Date.compareNowTo(otherTime: $0.DepartureTime)
                    && !$0.isTerminus
                
            }
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            //            Text(station?.StationName.En.uppercased() ?? "--").font(.headline)
            
            if (firstNth != nil) {
                
                
                
                
                
                
                NavigationLink(destination: TrainView(train: firstNth!)) {
                    TrainEntryListRowView(train: firstNth!)
                }
            }
            
            
            if (firstSth != nil && firstNth != nil) {
                Divider()
            }
            
            if (firstSth != nil) {
                
                NavigationLink(destination: TrainView(train: firstSth!)) {
                    TrainEntryListRowView(train: firstSth!)
                }
            }
        }
        .listRowBackground(Color(UIColor.systemGroupedBackground))
    }
    
}

//struct NearestStationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NearestStationView(station: )
//    }
//}
