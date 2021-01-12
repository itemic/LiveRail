//
//  TrainView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct TrainView: View {
    var train: StationTimetable
    @ObservedObject var vm: HSRViewModel
    
    var body: some View {
        ZStack {
        if (vm.train != nil) {
            List(vm.train!.StopTimes, id: \.StopSequence) { stop in
                HStack(alignment: .bottom) {
                    Text(stop.StationName.En)
                        .fontWeight(train.StationID == stop.StationID ? .black : .regular)
//                        .bold(train.StationID == stop.stationID)
                    Spacer()
                    Text("\(stop.ArrivalTime ?? "--:--")")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text("\(stop.DepartureTime)").font(.system(.body, design: .monospaced))
                        .fontWeight(train.StationID == stop.StationID ? .black : .regular)

                }
                
            }
        } else {
            
        }
        }
            .onAppear(perform: {
                vm.fetchTrainDetails(for: train.TrainNo, client: .init())
            })
        .navigationTitle("\(train.TrainNo) to \(train.EndingStationName.En)")
    }
}

//struct TrainView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainView()
//    }
//}
