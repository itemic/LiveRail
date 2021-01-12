//
//  LiveBoardListView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct LiveBoardListView: View {
    var train: StationTimetable
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.\(train.Direction == 0 ? "down" : "up")\(train.isTerminus ? ".to.line" : "")")
                .foregroundColor(train.Direction == 0 ? .green : .blue)
            VStack(alignment: .leading) {
                Text(train.TrainNo).bold()
                HStack {
                Text("\(train.EndingStationName.En)")
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(train.DepartureTime).font(.system(.body, design: .monospaced))
                    
            }
        }.foregroundColor(compareTime() ? .primary : .secondary)
    }
    
    func compareTime() -> Bool {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let departure = dateFormatter.date(from: train.DepartureTime)!
        return now.time < departure.time
        
    }
    
}




