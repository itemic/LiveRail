//
//  StationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct StationView: View {
    
    
    var station: Station
    @ObservedObject var data: HSRDataStore
    @State private var direction = 0
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("hideTerminus") var hideTerminus = false
    
    var body: some View {
        List {
        ForEach(data.stationTimetableDict[station]!.filter {
            (showAvailable ? compareTime(otherTime: $0.DepartureTime) : true) &&
                (hideTerminus ? !$0.isTerminus : true)
        }) { train in
            NavigationLink(destination: TrainView(train: train)) {
                LiveBoardListView(train: train)
            }.listRowBackground(Color(UIColor.systemGroupedBackground)) 
                   
            }
    }
                .navigationTitle(station.StationName.En)
            .onAppear(perform: {
                data.fetchTimetable(for: station, client: .init())
            })
        .listStyle(InsetGroupedListStyle())
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
        }
        .animation(.default)
        
    }
    
    func compareTime(otherTime: String) -> Bool {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let departure = dateFormatter.date(from: otherTime) else { return false }
        return now.time < departure.time
        
    }
    
}


//
//struct StationView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationView()
//    }
//}
