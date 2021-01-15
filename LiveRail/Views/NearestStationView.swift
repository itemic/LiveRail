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
                compareTime(otherTime: $0.DepartureTime)
                && !$0.isTerminus
            
        }
        }
        return nil
    }
    
    var firstSth: StationTimetable? {
        if let station = station {
        return data.stationTimetableDict[station]?.first {
            $0.Direction == 0 &&
                compareTime(otherTime: $0.DepartureTime)
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
            LiveBoardListView(train: firstNth!)
            }
            }
                

            if (firstSth != nil && firstNth != nil) {
                Divider()
            }
            
            if (firstSth != nil) {
                
                NavigationLink(destination: TrainView(train: firstSth!)) {
                    LiveBoardListView(train: firstSth!)
        }
            }
        }
        .listRowBackground(Color(UIColor.systemGroupedBackground))
    }
    
    func compareTime(otherTime: String) -> Bool {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let departure = dateFormatter.date(from: otherTime) else { return false }
        return now.time < departure.time
        
    }
}

//struct NearestStationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NearestStationView(station: )
//    }
//}
