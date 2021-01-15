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
            HStack {
                
                Text("N")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 40, alignment: .center)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                VStack(alignment: .leading) {
                    Text("\(firstNth!.TrainNo)").font(.system(.body, design: .rounded))
                    Text("\(firstNth!.EndingStationName.En)").bold().font(.body)
                }
                Spacer()
                    Text("\(firstNth!.DepartureTime)").font(.system(.body, design: .monospaced))
            }
            }
            }
                
            Divider()

            if (firstSth != nil) {
                Divider()
                NavigationLink(destination: TrainView(train: firstSth!)) {
            HStack {
                Text("S")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 40, alignment: .center)
                    .background(Color.green)
                    .clipShape(Rectangle())
                VStack(alignment: .leading) {
                    Text("\(firstSth!.TrainNo)").font(.system(.body, design: .rounded))
                    Text("\(firstSth!.EndingStationName.En)").bold().font(.body)
                }
                Spacer()
                Text("\(firstSth!.DepartureTime)").font(.system(.body, design: .monospaced))
            }
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
