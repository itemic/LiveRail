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
            
            Text("\(train.Direction == 0 ? "S" : "N")")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 20, height: 40, alignment: .center)
                .background(train.Direction == 0 ? Color.green : Color.blue)
                .clipShape(Rectangle())

            VStack(alignment: .leading) {
                Text("\(train.TrainNo)").font(.system(.body, design: .rounded))
                Text("\(train.EndingStationName.En)").bold().font(.body)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(train.DepartureTime)").font(.system(.body, design: .monospaced))

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




